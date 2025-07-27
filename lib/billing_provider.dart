import 'dart:async';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';


class SubscriptionsProvider with ChangeNotifier {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;

  // Your product IDs
  static const String simpleCalculationProductId = 'constructionprofitcalc.simplecalculation.3mo';
  static const String completeCalculationProductId = 'constructionprofitcalc.completecalculation.3mo';
  static const String completePlusSimpleCalculationProductId = 'constructionprofitcalc.fullaccess.6mo';

  // Product and purchase lists
  final List<ProductDetails> _products = [];
  final List<PurchaseDetails> _purchases = [];

  // Subscription status flags
  bool hasSimpleActiveSubscription = false;
  bool hasCompleteActiveSubscription = false;
  bool hasCompletePlusSimpleCalculationProductId = false;

  // Loading state
  bool _isLoading = false;

  StreamSubscription<List<PurchaseDetails>>? _subscription;

  // Project data instance (you might have this; just kept as-is)
  final dynamic projectData;

  SubscriptionsProvider(this.projectData) {
    _initialize(); // Automatically initialize when provider created
  }

  // Getters
  bool get available => true; // assumes always available; can be improved
  List<ProductDetails> get products => List.unmodifiable(_products);
  List<PurchaseDetails> get purchases => List.unmodifiable(_purchases);
  bool get isLoading => _isLoading;

  // Initialization: listen for purchase updates
  void _initialize() {
    final Stream<List<PurchaseDetails>> purchaseUpdated = _inAppPurchase.purchaseStream;

    _subscription = purchaseUpdated.listen(
          (purchaseDetailsList) {
        _handlePurchaseUpdates(purchaseDetailsList);
      },
      onDone: () {
        _subscription?.cancel();
      },
      onError: (error) {
        print("Purchase stream error: $error");
        _subscription?.cancel();
      },
    );
  }

  // Public method to initialize subscriptions (query products + restore purchases)
  Future<bool> initializeSubscriptions() async {
    _isLoading = true;
    notifyListeners();

    bool restorationSuccess = false;

    try {
      await querySubscriptionProducts();

      restorationSuccess = await restorePurchases();

      _updateSubscriptionStatus();

    } catch (e) {
      print("Error during subscription initialization: $e");
      // Reset all subs flags on error
      hasSimpleActiveSubscription = false;
      hasCompleteActiveSubscription = false;
      hasCompletePlusSimpleCalculationProductId = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }

    return restorationSuccess;
  }

  // Query available subscription products on the store
  Future<void> querySubscriptionProducts() async {
    try {
      final ProductDetailsResponse response = await _inAppPurchase.queryProductDetails(
        {
          simpleCalculationProductId,
          completeCalculationProductId,
          completePlusSimpleCalculationProductId,
        },
      );

      if (response.error != null) {
        throw Exception('Failed to query product details: ${response.error?.message ?? "Unknown error"}');
      }

      if (response.productDetails.isEmpty) {
        print('No available products found.');
        _products.clear();
        notifyListeners();
        return;
      }

      _products
        ..clear()
        ..addAll(response.productDetails);
      notifyListeners();
    } catch (e) {
      print("Error querying subscription products: $e");
      rethrow;
    }
  }

  // Restore purchases flow, returns true if any restored purchase exists
  bool _isRestoring = false;

  Future<bool> restorePurchases() async {
    if (_isRestoring) {
      print('Restore already in progress, ignoring duplicate call.');
      // Optionally return last known result or false
      return false;
    }
    _isRestoring = true;

    final completer = Completer<bool>();
    List<PurchaseDetails> restoredPurchases = [];
    late StreamSubscription<List<PurchaseDetails>> subscription;

    subscription = _inAppPurchase.purchaseStream.listen(
          (purchases) {
        _handlePurchaseUpdates(purchases);
        restoredPurchases.addAll(purchases.where((p) => p.status == PurchaseStatus.restored));

        if (purchases.every((p) => p.status != PurchaseStatus.pending)) {
          if (!completer.isCompleted) completer.complete(restoredPurchases.isNotEmpty);
          subscription.cancel();
        }
      },
      onDone: () {
        if (!completer.isCompleted) completer.complete(restoredPurchases.isNotEmpty);
        subscription.cancel();
      },
      onError: (error) {
        print("Purchase stream error during restore: $error");
        if (!completer.isCompleted) completer.complete(false);
        subscription.cancel();
      },
    );

    try {
      await _inAppPurchase.restorePurchases();

      final result = await completer.future.timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          print("Restore purchases timed out");
          subscription.cancel();
          return false;
        },
      );
      _isRestoring = false;
      return result;
    } catch(e) {
      print('Exception during restorePurchases: $e');
      _isRestoring = false;
      return false;
    }
  }


  // Check if a product is purchased or restored
  bool isProductPurchased(String productId) {
    return _purchases.any((purchase) =>
    purchase.productID == productId &&
        (purchase.status == PurchaseStatus.purchased || purchase.status == PurchaseStatus.restored));
  }

  // Central method to update subscription flags based on _purchases
  void _updateSubscriptionStatus() {
    hasSimpleActiveSubscription = isProductPurchased(simpleCalculationProductId);
    hasCompleteActiveSubscription = isProductPurchased(completeCalculationProductId);
    hasCompletePlusSimpleCalculationProductId = isProductPurchased(completePlusSimpleCalculationProductId);

    notifyListeners();
  }

  // Handle incoming purchase updates
  void _handlePurchaseUpdates(List<PurchaseDetails> purchasesList) {
    bool updated = false; // Track if any new purchase added

    for (var purchase in purchasesList) {
      if (purchase.status == PurchaseStatus.pending) {
        print("Purchase is pending: ${purchase.productID}");
      } else if (purchase.status == PurchaseStatus.purchased || purchase.status == PurchaseStatus.restored) {
        print("Purchase successful or restored: ${purchase.productID}");

        if (purchase.pendingCompletePurchase) {
          _inAppPurchase.completePurchase(purchase);
        }

        // Only add if purchaseID is not already in _purchases
        if (!_purchases.any((p) => p.purchaseID == purchase.purchaseID)) {
          _purchases.add(purchase);
          updated = true;
        }
      } else if (purchase.status == PurchaseStatus.error) {
        print("Error purchasing: ${purchase.error?.message}");
      } else if (purchase.status == PurchaseStatus.canceled) {
        print("Purchase was canceled: ${purchase.productID}");
      }
    }

    if (updated) {
      _updateSubscriptionStatus();
    }
  }

  // Method to initiate a subscription purchase
  Future<bool> buySubscription(ProductDetails productDetails) async {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: productDetails);

    try {
      await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);

      // No need to explicitly restore purchases here; purchaseStream updates will arrive.

      return true;
    } catch (e) {
      print("Error purchasing subscription: $e");
      return false;
    }
  }

  // Dispose subscription listener when provider is disposed
  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  // UI: Show simple subscription UI dialog with subscribe & restore buttons
  Future<void> showSimpleSubscriptionUI(BuildContext context) async {
    final subscriptionsProvider = context.read<SubscriptionsProvider>();

    try {
      final ProductDetailsResponse response = await _inAppPurchase.queryProductDetails({
        simpleCalculationProductId,
        completeCalculationProductId,
        completePlusSimpleCalculationProductId,
      });

      if (response.error != null) {
        _showErrorDialog(context, response.error!.message);
        return;
      }

      if (response.productDetails.isEmpty) {
        _showNoSubscriptionDialog(context);
        return;
      }

      // Update products list if you keep track internally (optional)
      _products
        ..clear()
        ..addAll(response.productDetails);

      // Build subscription buttons without conditions
      List<Widget> subscriptionTiles = [
        const SizedBox(height: 20),

        // Simple Calculation subscription button
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green.shade700,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: const Text(
            'Subscribe to Simple Calculation for 3 months',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
          onPressed: () async {
            try {
              final product = response.productDetails.firstWhere(
                    (product) => product.id == simpleCalculationProductId,
                orElse: () => throw Exception('Simple Calculation product not found'),
              );
              await subscriptionsProvider.buySubscription(product);
              Navigator.of(context).pop();
            } catch (e) {
              _showErrorDialog(context, e.toString());
            }
          },
        ),

        const SizedBox(height: 20),

        // Both Simple + Complete subscription button
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green.shade700,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: const Text(
            'Subscribe to Both Simple and Complete Calculations for 6 months',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
          onPressed: () async {
            try {
              final product = response.productDetails.firstWhere(
                    (product) => product.id == completePlusSimpleCalculationProductId,
                orElse: () => throw Exception('Combined product not found'),
              );
              await subscriptionsProvider.buySubscription(product);
              Navigator.of(context).pop();
            } catch (e) {
              _showErrorDialog(context, e.toString());
            }
          },
        ),

        const SizedBox(height: 20),

        // Restore Purchases button
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: const Text(
            'Restore Purchases',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
          onPressed: () async {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => const Center(child: CircularProgressIndicator()),
            );

            try {
              bool restorationSuccess = await subscriptionsProvider.initializeSubscriptions();
              print("Restore Purchases Result: $restorationSuccess");
            } catch (e) {
              print("Error restoring purchases: $e");
              _showErrorDialog(context, e.toString());
            }

            await Future.delayed(const Duration(seconds: 3));
            Navigator.of(context, rootNavigator: true).pop();

            // Optionally, show a Snackbar if no subscriptions found after restore
            if (!subscriptionsProvider.hasSimpleActiveSubscription &&
                !subscriptionsProvider.hasCompletePlusSimpleCalculationProductId) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('No active subscriptions found. Please purchase a subscription.')),
              );
            }
          },
        ),

        const SizedBox(height: 20),
      ];

      // Show the dialog containing subscription options
      await showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Subscriptions Required'),
          contentPadding: const EdgeInsets.all(16.0),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: subscriptionTiles,
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.grey.shade200,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Close'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    } catch (e) {
      _showErrorDialog(context, e.toString());
    }
  }


  Future<void> showCompleteSubscriptionUI(BuildContext context) async {
    final subscriptionsProvider = context.read<SubscriptionsProvider>();

    try {
      final ProductDetailsResponse response = await _inAppPurchase.queryProductDetails({
        simpleCalculationProductId,
        completeCalculationProductId,
        completePlusSimpleCalculationProductId,
      });

      if (response.error != null) {
        _showErrorDialog(context, response.error!.message);
        return;
      }

      if (response.productDetails.isEmpty) {
        _showNoSubscriptionDialog(context);
        return;
      }

      // Clear and update product list
      _products
        ..clear()
        ..addAll(response.productDetails);

      List<Widget> subscriptionTiles = [
        const SizedBox(height: 20),

        // Complete Calculation subscription button
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green.shade700,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: const Text(
            'Subscribe to Complete Calculation for 3 months',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
          onPressed: () async {
            try {
              final product = response.productDetails.firstWhere(
                    (product) => product.id == completeCalculationProductId,
                orElse: () => throw Exception('Complete Calculation product not found'),
              );
              await subscriptionsProvider.buySubscription(product);
              Navigator.of(context).pop();
            } catch (e) {
              _showErrorDialog(context, e.toString());
            }
          },
        ),

        const SizedBox(height: 20),

        // Combined subscription button
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green.shade700,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: const Text(
            'Subscribe to Both Simple and Complete Calculations for 6 months',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
          onPressed: () async {
            try {
              final product = response.productDetails.firstWhere(
                    (product) => product.id == completePlusSimpleCalculationProductId,
                orElse: () => throw Exception('Combined product not found'),
              );
              await subscriptionsProvider.buySubscription(product);
              Navigator.of(context).pop();
            } catch (e) {
              _showErrorDialog(context, e.toString());
            }
          },
        ),

        const SizedBox(height: 20),

        // Restore Purchases button
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: const Text(
            'Restore Purchases',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
          onPressed: () async {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => const Center(child: CircularProgressIndicator()),
            );

            try {
              bool restorationSuccess = await subscriptionsProvider.initializeSubscriptions();
              print("Restore Purchases Result: $restorationSuccess");
            } catch (e) {
              print("Error restoring purchases: $e");
              _showErrorDialog(context, e.toString());
            }

            await Future.delayed(const Duration(seconds: 3));
            Navigator.of(context, rootNavigator: true).pop();

            // Show Snackbar only if still no active subscription after restore
            if (!subscriptionsProvider.hasSimpleActiveSubscription &&
                !subscriptionsProvider.hasCompleteActiveSubscription &&
                !subscriptionsProvider.hasCompletePlusSimpleCalculationProductId) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('No active subscriptions found. Please purchase a subscription.')),
              );
            }
          },
        ),

        const SizedBox(height: 20),
      ];

      // Show dialog
      await showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Subscriptions Required'),
          contentPadding: const EdgeInsets.all(16.0),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: subscriptionTiles,
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.grey.shade200,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Close'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    } catch (e) {
      _showErrorDialog(context, e.toString());
    }
  }


  // Dialog helpers
  void _showErrorDialog(BuildContext context, String message) {
    final screenWidth = MediaQuery.of(context).size.width;
    const ipadBreakpoint = 850.0;
    final bool isIpad = screenWidth > ipadBreakpoint;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text('Error querying subscription products: $message'),
          actions: <Widget>[
            TextButton(
              child: Text(
                'OK',
                style: TextStyle(
                  fontSize: isIpad ? 40 : 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  void _showNoSubscriptionDialog(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    const ipadBreakpoint = 850.0;
    final bool isIpad = screenWidth > ipadBreakpoint;

    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('No Subscription Available'),
        content: const Text('No subscriptions found. Please check your account.'),
        actions: <Widget>[
          TextButton(
            child: Text(
              'OK',
              style: TextStyle(
                fontSize: isIpad ? 40 : 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}

