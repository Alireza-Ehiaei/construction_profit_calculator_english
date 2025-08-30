import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';


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

  Future<void> showManageSubscriptions(BuildContext context) async {
    final subscriptionsProvider = context.read<SubscriptionsProvider>();
    const String simpleCalculationProductId = 'com.tech4dev.construction.simple.3m';

    // Check if Simple Calculation is active
    bool hasSimpleActive = subscriptionsProvider.hasSimpleActiveSubscription;

    // Build dialog content
    String message = hasSimpleActive
        ? 'You have an active Simple Calculation subscription (\$5.99/3 months) for Simple Calculation product. Manage or cancel it below.'
        : 'No active Simple Calculation subscription found. Subscribe to access Simple Calculation.';

    await showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Manage Subscriptions'),
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16),
        ),
        actions: [
          if (hasSimpleActive)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () async {
                try {
                  // Call platform channel to open StoreKit's subscription management
                  await const MethodChannel('com.tech4dev.construction/subscriptions')
                      .invokeMethod('showManageSubscriptions');
                  Navigator.of(context).pop();
                } catch (e) {
                  Navigator.of(context).pop();
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Error'),
                      content: const Text('Error opening subscription management. Please go to iOS Settings > Your Apple ID > Subscriptions to manage.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                }
              },
              child: const Text('Manage/Cancel Simple Calculation', style: TextStyle(fontSize: 16)),
            ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }



// Helper method to build subscription buttons
  Widget _buildSubscriptionButton({
    required BuildContext context,
    required SubscriptionsProvider provider,
    required String productId,
    required ProductDetailsResponse response,
    required String title,
    required String description,
    required bool enabled,
    String? disabledMessage,
  }) {
    return Column(
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: enabled ? Colors.green.shade700 : Colors.grey,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onPressed: enabled
              ? () async {
            try {
              final product = response.productDetails.firstWhere(
                    (product) => product.id == productId,
                orElse: () => throw Exception('$productId not found'),
              );
              await provider.buySubscription(product);
              Navigator.of(context).pop();
            } catch (e) {
              _showErrorDialog(context, e.toString());
            }
          }
              : null,
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          child: Text(
            enabled ? description : disabledMessage ?? description,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: enabled ? Colors.black : Colors.grey),
          ),
        ),
      ],
    );
  }

// Helper method to launch URLs
  Future<void> _launchUrl(BuildContext context, String url) async {
    try {
      await launchUrl(Uri.parse(url));
    } catch (e) {
      _showErrorDialog(context, 'Error opening URL: $e');
    }
  }


  Future<void> showSimpleSubscriptionUI(BuildContext context) async {
    final subscriptionsProvider = context.read<SubscriptionsProvider>();
    const String simpleCalculationProductId = 'com.tech4dev.construction.simple.3m';
    const String completePlusSimpleCalculationProductId = 'com.tech4dev.construction.full.6m';

    // Mock subscription data for Android Studio testing
    final bool isDebugMode = !kReleaseMode;
    List<ProductDetails> mockProducts = isDebugMode
        ? [
      ProductDetails(
        id: simpleCalculationProductId,
        title: 'Simple Calculation',
        description: 'Access Simple Calculation for basic construction cost estimates for 3 months.',
        price: '\$5.99',
        rawPrice: 5.99,
        currencyCode: 'USD',
      ),
      ProductDetails(
        id: completePlusSimpleCalculationProductId,
        title: 'Full Access',
        description: 'Access both Simple Calculation and Complete Calculation for 6 months, saving 60%.',
        price: '\$12.99',
        rawPrice: 12.99,
        currencyCode: 'USD',
      ),
    ]
        : [];

    ProductDetailsResponse response;
    if (isDebugMode) {
      response = ProductDetailsResponse(productDetails: mockProducts, notFoundIDs: []);
      print('Debug: Mock ProductDetailsResponse: ${response.productDetails.map((p) => p.id).toList()}');
    } else {
      try {
        response = await InAppPurchase.instance.queryProductDetails({
          simpleCalculationProductId,
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
      } catch (e) {
        _showErrorDialog(context, e.toString());
        return;
      }
    }

    // Check active subscriptions (use mock state for debugging)
    bool hasFullAccess = isDebugMode ? false : subscriptionsProvider.hasCompletePlusSimpleCalculationProductId;
    bool hasSimpleActive = isDebugMode ? false : subscriptionsProvider.hasSimpleActiveSubscription;
    if (isDebugMode) {
      print('Debug: hasFullAccess=$hasFullAccess, hasSimpleActive=$hasSimpleActive');
    }

    List<Widget> subscriptionTiles = [
      const SizedBox(height: 20),
      // Simple Calculation subscription
      SizedBox(
        width: 300,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green.shade700,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(color: hasFullAccess ? Colors.grey : Colors.green.shade700),
            ),
            elevation: 0,
          ),
          onPressed: hasFullAccess
              ? null
              : () async {
            if (isDebugMode) {
              print('Debug: Simulating purchase of $simpleCalculationProductId');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Debug: Simulated purchase of $simpleCalculationProductId')),
              );
              Navigator.of(context).pop();
            } else {
              try {
                final product = response.productDetails.firstWhere(
                      (product) => product.id == simpleCalculationProductId,
                  orElse: () => throw Exception('$simpleCalculationProductId not found'),
                );
                await subscriptionsProvider.buySubscription(product);
                Navigator.of(context).pop();
              } catch (e) {
                _showErrorDialog(context, e.toString());
              }
            }
          },
          child: const Text(
            'Simple Calculation\n\$5.99 / 3 months',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
      ),
      const SizedBox(height: 12),
      // Full Access subscription
      SizedBox(
        width: 300,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green.shade700,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(color: Colors.green.shade700),
            ),
            elevation: 0,
          ),
          onPressed: () async {
            if (isDebugMode) {
              print('Debug: Simulating purchase of $completePlusSimpleCalculationProductId');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Debug: Simulated purchase of $completePlusSimpleCalculationProductId')),
              );
              Navigator.of(context).pop();
            } else {
              try {
                final product = response.productDetails.firstWhere(
                      (product) => product.id == completePlusSimpleCalculationProductId,
                  orElse: () => throw Exception('$completePlusSimpleCalculationProductId not found'),
                );
                await subscriptionsProvider.buySubscription(product);
                Navigator.of(context).pop();
              } catch (e) {
                _showErrorDialog(context, e.toString());
              }
            }
          },
          child: const Text(
            'Full Access\n\$12.99 / 6 months',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
      ),
      const SizedBox(height: 12),
      const Text(
        'Save 50% by subscribing to Full Access!',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.green,
        ),
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 20),
      // Learn More/Cancel Subscription button
      SizedBox(
        width: 300,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: null,
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: const BorderSide(color: Colors.black),
            ),
            elevation: 0,
          ),
          onPressed: () async {
            print('Debug: Showing subscription info dialog');
            await showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('Subscription Info'),
                content: Text(
                  'Choose your calculation method:\n\n'
                      '• Simple: Uniform rate (sqft/sqm) for the entire project\n'
                      '• Complete: Custom rates (sqft/sqm) for each project part\n\n'
                      'Tap ? icon at the bottom of the first page of each product for details, especially during your trial. '
                      '\n\nStatus: ${hasSimpleActive || hasFullAccess ?
                  'Active ${hasFullAccess ? "Full Access" : "Simple"} subscription. ${hasFullAccess ? "" : "Upgrade to get both."}' : "No active subscription."}',
                  textAlign: TextAlign.left,
                  style: const TextStyle(fontSize: 20, height: 1.5, fontWeight: FontWeight.bold),
                ),
                actions: [
                  if (hasSimpleActive || hasFullAccess)
                    TextButton(
                      onPressed: () async {
                        if (isDebugMode) {
                          print('Debug: Simulating cancel subscription');
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Debug: Simulated cancel subscription')),
                          );
                          Navigator.of(context).pop();
                        } else {
                          try {
                            await const MethodChannel('com.tech4dev.construction/subscriptions')
                                .invokeMethod('showManageSubscriptions');
                            Navigator.of(context).pop();
                          } catch (e) {
                            Navigator.of(context).pop();
                            _showErrorDialog(context, 'Error opening subscription management. Go to iOS Settings > Your Apple ID > Subscriptions.');
                          }
                        }
                      },
                      child: const Text('Cancel Subscription', style: TextStyle(fontSize: 16)),
                    ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('OK', style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            );
          },
          child: const Text(
            'Learn More \nCancel Subscription',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
      ),
      const SizedBox(height: 12),
      // Restore Purchases button
      SizedBox(
        width: 300,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: null,
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: const BorderSide(color: Colors.black),
            ),
            elevation: 0,
          ),
          onPressed: () async {
            print('Debug: Simulating restore purchases');
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => const Center(child: CircularProgressIndicator()),
            );
            if (isDebugMode) {
              await Future.delayed(const Duration(seconds: 1)); // Simulate async work
              Navigator.of(context, rootNavigator: true).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Debug: Simulated restore purchases')),
              );
            } else {
              try {
                bool restorationSuccess = await subscriptionsProvider.initializeSubscriptions();
                Navigator.of(context, rootNavigator: true).pop();
                if (!restorationSuccess &&
                    !subscriptionsProvider.hasSimpleActiveSubscription &&
                    !subscriptionsProvider.hasCompletePlusSimpleCalculationProductId) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('No active subscriptions found. Please purchase a subscription.')),
                  );
                }
              } catch (e) {
                Navigator.of(context, rootNavigator: true).pop();
                _showErrorDialog(context, e.toString());
              }
            }
          },
          child: const Text(
            'Restore Purchases',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
      ),
      const SizedBox(height: 20),
      // Privacy Policy and Terms of Use links
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () => _launchUrl(context, 'https://www.termsfeed.com/live/228b3ef3-78b7-4838-a02a-77fb59345193'),
            child: const Text(
              'Privacy Policy',
              style: TextStyle(
                fontSize: 16,
                color: Colors.blue,
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          const SizedBox(width: 16),
          TextButton(
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () => _launchUrl(context, 'https://www.apple.com/legal/internet-services/itunes/us/terms.html'),
            child: const Text(
              'Terms of Use',
              style: TextStyle(
                fontSize: 16,
                color: Colors.blue,
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 20),
    ];

    await showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text(
          'Choose a Subscription',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        contentPadding: const EdgeInsets.all(16.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: Colors.white,
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: subscriptionTiles,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }

/*Future<void> showSimpleSubscriptionUI(BuildContext context) async {
    final subscriptionsProvider = context.read<SubscriptionsProvider>();
    const String simpleCalculationProductId = 'com.tech4dev.construction.simple.3m';
    const String completePlusSimpleCalculationProductId = 'com.tech4dev.construction.full.6m';

    // Fetch subscription data from StoreKit
    ProductDetailsResponse response;
    try {
      response = await InAppPurchase.instance.queryProductDetails({
        simpleCalculationProductId,
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
    } catch (e) {
      _showErrorDialog(context, e.toString());
      return;
    }

    // Check active subscriptions
    bool hasFullAccess = subscriptionsProvider.hasCompletePlusSimpleCalculationProductId;
    bool hasSimpleActive = subscriptionsProvider.hasSimpleActiveSubscription;

    List<Widget> subscriptionTiles = [
      const SizedBox(height: 20),
      // Simple Calculation subscription
      SizedBox(
        width: 300,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green.shade700,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(color: hasFullAccess ? Colors.grey : Colors.green.shade700),
            ),
            elevation: 0,
          ),
          onPressed: hasFullAccess
              ? null
              : () async {
            try {
              final product = response.productDetails.firstWhere(
                    (product) => product.id == simpleCalculationProductId,
                orElse: () => throw Exception('$simpleCalculationProductId not found'),
              );
              await subscriptionsProvider.buySubscription(product);
              Navigator.of(context).pop();
            } catch (e) {
              _showErrorDialog(context, e.toString());
            }
          },
          child: const Text(
            'Simple Calculation\n\$5.99 / 3 months',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
      ),
      const SizedBox(height: 12),
      // Full Access subscription
      SizedBox(
        width: 300,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green.shade700,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(color: Colors.green.shade700),
            ),
            elevation: 0,
          ),
          onPressed: () async {
            try {
              final product = response.productDetails.firstWhere(
                    (product) => product.id == completePlusSimpleCalculationProductId,
                orElse: () => throw Exception('$completePlusSimpleCalculationProductId not found'),
              );
              await subscriptionsProvider.buySubscription(product);
              Navigator.of(context).pop();
            } catch (e) {
              _showErrorDialog(context, e.toString());
            }
          },
          child: const Text(
            'Full Access\n\$12.99 / 6 months',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
      ),

       const SizedBox(height: 12),
      const Text(
        'Save 50% by subscribing to Full Access!',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.green,
        ),
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 20),
      // Learn More\nCancel Subscription button
      SizedBox(
        width: 300,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: null,
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: const BorderSide(color: Colors.black),
            ),
            elevation: 0,
          ),
          onPressed: () async {
            await showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('Subscription Info'),
                content: Text(
                  'Choose your calculation method:\n\n'
                      '• Simple: Uniform rate (sqft/sqm) for the entire project\n'
                      '• Complete: Custom rates (sqft/sqm) for each project part\n\n'
                      'Tap ? icon at the bottom of the first page of each product for details, especially during your trial. '
                      '\n\nStatus: ${hasSimpleActive || hasFullAccess ? 'Active ${hasFullAccess ? "Full Access" : "Simple"} subscription. ${hasFullAccess ? "" : "Upgrade to get both."}' : "No active subscription."}',
                  textAlign: TextAlign.left,
                  style: const TextStyle(fontSize: 20, height: 1.5, fontWeight: FontWeight.bold),
                ),
                actions: [
                  if (hasSimpleActive || hasFullAccess)
                    TextButton(
                      onPressed: () async {
                        try {
                          await const MethodChannel('com.tech4dev.construction/subscriptions')
                              .invokeMethod('showManageSubscriptions');
                          Navigator.of(context).pop();
                        } catch (e) {
                          Navigator.of(context).pop();
                          _showErrorDialog(context, 'Error opening subscription management. Go to iOS Settings > Your Apple ID > Subscriptions.');
                        }
                      },
                      child: const Text('Cancel Subscription', style: TextStyle(fontSize: 16)),
                    ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('OK', style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            );
          },
          child: const Text(
            'Learn More \nCancel Subscription',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
      ),
      const SizedBox(height: 12),
      // Restore Purchases button
      SizedBox(
        width: 300,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: null,
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: const BorderSide(color: Colors.black),
            ),
            elevation: 0,
          ),
          onPressed: () async {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => const Center(child: CircularProgressIndicator()),
            );
            try {
              bool restorationSuccess = await subscriptionsProvider.initializeSubscriptions();
              Navigator.of(context, rootNavigator: true).pop();
              if (!restorationSuccess &&
                  !subscriptionsProvider.hasSimpleActiveSubscription &&
                  !subscriptionsProvider.hasCompletePlusSimpleCalculationProductId) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('No active subscriptions found. Please purchase a subscription.')),
                );
              }
            } catch (e) {
              Navigator.of(context, rootNavigator: true).pop();
              _showErrorDialog(context, e.toString());
            }
          },
          child: const Text(
            'Restore Purchases',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
      ),
      const SizedBox(height: 20),
      // Privacy Policy and Terms of Use links
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () => _launchUrl(context, 'https://www.termsfeed.com/live/228b3ef3-78b7-4838-a02a-77fb59345193'),
            child: const Text(
              'Privacy Policy',
              style: TextStyle(
                fontSize: 16,
                color: Colors.blue,
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          const SizedBox(width: 16),
          TextButton(
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () => _launchUrl(context, 'https://www.apple.com/legal/internet-services/itunes/us/terms.html'),
            child: const Text(
              'Terms of Use',
              style: TextStyle(
                fontSize: 16,
                color: Colors.blue,
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 20),
    ];

    await showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text(
          'Choose a Subscription',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        contentPadding: const EdgeInsets.all(16.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: Colors.white,
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: subscriptionTiles,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }*/


  Future<void> showCompleteSubscriptionUI(BuildContext context) async {
    final subscriptionsProvider = context.read<SubscriptionsProvider>();
    const String completeCalculationProductId = 'com.tech4dev.construction.complete.3m';
    const String completePlusSimpleCalculationProductId = 'com.tech4dev.construction.full.6m';

    // Mock subscription data for Android Studio testing
    final bool isDebugMode = !kReleaseMode;
    List<ProductDetails> mockProducts = isDebugMode
        ? [
      ProductDetails(
        id: completeCalculationProductId,
        title: 'Complete Calculation',
        description: 'Access Complete Calculation for custom construction cost estimates for 3 months.',
        price: '\$6.99',
        rawPrice: 6.99,
        currencyCode: 'USD',
      ),
      ProductDetails(
        id: completePlusSimpleCalculationProductId,
        title: 'Full Access',
        description: 'Access both Simple Calculation and Complete Calculation for 6 months, saving 60%.',
        price: '\$12.99',
        rawPrice: 12.99,
        currencyCode: 'USD',
      ),
    ]
        : [];

    ProductDetailsResponse response;
    if (isDebugMode) {
      response = ProductDetailsResponse(productDetails: mockProducts, notFoundIDs: []);
      print('Debug: Mock ProductDetailsResponse: ${response.productDetails.map((p) => p.id).toList()}');
    } else {
      try {
        response = await InAppPurchase.instance.queryProductDetails({
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
      } catch (e) {
        _showErrorDialog(context, e.toString());
        return;
      }
    }

    // Check active subscriptions (use mock state for debugging)
    bool hasFullAccess = isDebugMode ? false : subscriptionsProvider.hasCompletePlusSimpleCalculationProductId;
    bool hasCompleteActive = isDebugMode ? false : subscriptionsProvider.hasCompleteActiveSubscription;
    if (isDebugMode) {
      print('Debug: hasFullAccess=$hasFullAccess, hasCompleteActive=$hasCompleteActive');
    }

    List<Widget> subscriptionTiles = [
      const SizedBox(height: 20),
      // Complete Calculation subscription
      SizedBox(
        width: 300,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green.shade700,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(color: hasFullAccess ? Colors.grey : Colors.green.shade700),
            ),
            elevation: 0,
          ),
          onPressed: hasFullAccess
              ? null
              : () async {
            if (isDebugMode) {
              print('Debug: Simulating purchase of $completeCalculationProductId');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Debug: Simulated purchase of $completeCalculationProductId')),
              );
              Navigator.of(context).pop();
            } else {
              try {
                final product = response.productDetails.firstWhere(
                      (product) => product.id == completeCalculationProductId,
                  orElse: () => throw Exception('$completeCalculationProductId not found'),
                );
                await subscriptionsProvider.buySubscription(product);
                Navigator.of(context).pop();
              } catch (e) {
                _showErrorDialog(context, e.toString());
              }
            }
          },
          child: const Text(
            'Complete Calculation\n\$6.99 / 3 months',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
      ),
      const SizedBox(height: 12),
      // Full Access subscription
      SizedBox(
        width: 300,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green.shade700,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(color: Colors.green.shade700),
            ),
            elevation: 0,
          ),
          onPressed: () async {
            if (isDebugMode) {
              print('Debug: Simulating purchase of $completePlusSimpleCalculationProductId');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Debug: Simulated purchase of $completePlusSimpleCalculationProductId')),
              );
              Navigator.of(context).pop();
            } else {
              try {
                final product = response.productDetails.firstWhere(
                      (product) => product.id == completePlusSimpleCalculationProductId,
                  orElse: () => throw Exception('$completePlusSimpleCalculationProductId not found'),
                );
                await subscriptionsProvider.buySubscription(product);
                Navigator.of(context).pop();
              } catch (e) {
                _showErrorDialog(context, e.toString());
              }
            }
          },
          child: const Text(
            'Full Access\n\$12.99 / 6 months',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
      ),
      const SizedBox(height: 12),
      const Text(
        'Save 50% by subscribing to Full Access!',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.green,
        ),
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 20),
      // Learn More/Cancel Subscription button
      SizedBox(
        width: 300,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: null,
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: const BorderSide(color: Colors.black),
            ),
            elevation: 0,
          ),
          onPressed: () async {
            print('Debug: Showing subscription info dialog');
            await showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('Subscription Info'),
                content: Text(
                  'Choose your calculation method:\n\n'
                      '• Simple: Uniform rate (sqft/sqm) for the entire project\n'
                      '• Complete: Custom rates (sqft/sqm) for each project part\n\n'
                      'Tap ? icon at the bottom of the first page of each product for details, especially during your trial. '
                      'Full Access includes both methods at a significant discount.\n\n'
                      '\n\nStatus: ${hasCompleteActive || hasFullAccess ? 'Active ${hasFullAccess ? "Full Access" : "Complete"} subscription. ${hasFullAccess ? "" : "Upgrade to get both."}' : "No active subscription."}',
                  textAlign: TextAlign.left,
                  style: const TextStyle(fontSize: 20, height: 1.5, fontWeight: FontWeight.bold),
                ),
                actions: [
                  if (hasCompleteActive || hasFullAccess)
                    TextButton(
                      onPressed: () async {
                        if (isDebugMode) {
                          print('Debug: Simulating cancel subscription');
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Debug: Simulated cancel subscription')),
                          );
                          Navigator.of(context).pop();
                        } else {
                          try {
                            await const MethodChannel('com.tech4dev.construction/subscriptions')
                                .invokeMethod('showManageSubscriptions');
                            Navigator.of(context).pop();
                          } catch (e) {
                            Navigator.of(context).pop();
                            _showErrorDialog(context, 'Error opening subscription management. Go to iOS Settings > Your Apple ID > Subscriptions.');
                          }
                        }
                      },
                      child: const Text('Cancel Subscription', style: TextStyle(fontSize: 16)),
                    ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('OK', style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            );
          },
          child: const Text(
            'Learn More\nCancel Subscription',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
      ),
      const SizedBox(height: 12),
      // Restore Purchases button
      SizedBox(
        width: 300,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: null,
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: const BorderSide(color: Colors.black),
            ),
            elevation: 0,
          ),
          onPressed: () async {
            print('Debug: Simulating restore purchases');
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => const Center(child: CircularProgressIndicator()),
            );
            if (isDebugMode) {
              await Future.delayed(const Duration(seconds: 1)); // Simulate async work
              Navigator.of(context, rootNavigator: true).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Debug: Simulated restore purchases')),
              );
            } else {
              try {
                bool restorationSuccess = await subscriptionsProvider.initializeSubscriptions();
                Navigator.of(context, rootNavigator: true).pop();
                if (!restorationSuccess &&
                    !subscriptionsProvider.hasCompleteActiveSubscription &&
                    !subscriptionsProvider.hasCompletePlusSimpleCalculationProductId) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('No active subscriptions found. Please purchase a subscription.')),
                  );
                }
              } catch (e) {
                Navigator.of(context, rootNavigator: true).pop();
                _showErrorDialog(context, e.toString());
              }
            }
          },
          child: const Text(
            'Restore Purchases',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
      ),
      const SizedBox(height: 20),
      // Privacy Policy and Terms of Use links
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () => _launchUrl(context, 'https://www.termsfeed.com/live/228b3ef3-78b7-4838-a02a-77fb59345193'),
            child: const Text(
              'Privacy Policy',
              style: TextStyle(
                fontSize: 16,
                color: Colors.blue,
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          const SizedBox(width: 16),
          TextButton(
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () => _launchUrl(context, 'https://www.apple.com/legal/internet-services/itunes/us/terms.html'),
            child: const Text(
              'Terms of Use',
              style: TextStyle(
                fontSize: 16,
                color: Colors.blue,
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 20),
    ];

    await showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text(
          'Choose a Subscription',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        contentPadding: const EdgeInsets.all(16.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: Colors.white,
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: subscriptionTiles,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }

/*  Future<void> showCompleteSubscriptionUI(BuildContext context) async {
    final subscriptionsProvider = context.read<SubscriptionsProvider>();
    const String completeCalculationProductId = 'com.tech4dev.construction.complete.3m';
    const String completePlusSimpleCalculationProductId = 'com.tech4dev.construction.full.6m';

    // Fetch subscription data from StoreKit
    ProductDetailsResponse response;
    try {
      response = await InAppPurchase.instance.queryProductDetails({
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
    } catch (e) {
      _showErrorDialog(context, e.toString());
      return;
    }

    // Check active subscriptions
    bool hasFullAccess = subscriptionsProvider.hasCompletePlusSimpleCalculationProductId;
    bool hasCompleteActive = subscriptionsProvider.hasCompleteActiveSubscription;

    List<Widget> subscriptionTiles = [
      const SizedBox(height: 20),
      // Complete Calculation subscription
      SizedBox(
        width: 300,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green.shade700,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(color: hasFullAccess ? Colors.grey : Colors.green.shade700),
            ),
            elevation: 0,
          ),
          onPressed: hasFullAccess
              ? null
              : () async {
            try {
              final product = response.productDetails.firstWhere(
                    (product) => product.id == completeCalculationProductId,
                orElse: () => throw Exception('$completeCalculationProductId not found'),
              );
              await subscriptionsProvider.buySubscription(product);
              Navigator.of(context).pop();
            } catch (e) {
              _showErrorDialog(context, e.toString());
            }
          },
          child: const Text(
            'Complete Calculation\n\$6.99 / 3 months',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
      ),
      const SizedBox(height: 12),
      // Full Access subscription
      SizedBox(
        width: 300,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green.shade700,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(color: Colors.green.shade700),
            ),
            elevation: 0,
          ),
          onPressed: () async {
            try {
              final product = response.productDetails.firstWhere(
                    (product) => product.id == completePlusSimpleCalculationProductId,
                orElse: () => throw Exception('$completePlusSimpleCalculationProductId not found'),
              );
              await subscriptionsProvider.buySubscription(product);
              Navigator.of(context).pop();
            } catch (e) {
              _showErrorDialog(context, e.toString());
            }
          },
          child: const Text(
            'Full Access\n\$12.99 / 6 months',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
      ),
      const SizedBox(height: 12),
      const Text(
        'Save 50% by subscribing to Full Access!',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.green,
        ),
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 20),
      // Learn More/Cancel Subscription button
      SizedBox(
        width: 300,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: null,
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: const BorderSide(color: Colors.black),
            ),
            elevation: 0,
          ),
          onPressed: () async {
            await showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('Subscription Info'),
                content: Text(
                  'Choose your calculation method:\n\n'
                      '• Simple: Uniform rate (sqft/sqm) for the entire project\n'
                      '• Complete: Custom rates (sqft/sqm) for each project part\n\n'
                      'Tap ? icon at the bottom of the first page of each product for details, especially during your trial. '
                      '\n\nStatus: ${hasCompleteActive || hasFullAccess ? 'Active ${hasFullAccess ? "Full Access" : "Complete"} subscription. ${hasFullAccess ? "" : "Upgrade to get both."}' : "No active subscription."}',
                  textAlign: TextAlign.left,
                  style: const TextStyle(fontSize: 20, height: 1.5, fontWeight: FontWeight.bold),
                ),
                actions: [
                  if (hasCompleteActive || hasFullAccess)
                    TextButton(
                      onPressed: () async {
                        try {
                          await const MethodChannel('com.tech4dev.construction/subscriptions')
                              .invokeMethod('showManageSubscriptions');
                          Navigator.of(context).pop();
                        } catch (e) {
                          Navigator.of(context).pop();
                          _showErrorDialog(context, 'Error opening subscription management. Go to iOS Settings > Your Apple ID > Subscriptions.');
                        }
                      },
                      child: const Text('Cancel Subscription', style: TextStyle(fontSize: 16)),
                    ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('OK', style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            );
          },
          child: const Text(
            'Learn More\nCancel Subscription',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
      ),
      const SizedBox(height: 12),
      // Restore Purchases button
      SizedBox(
        width: 300,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: null,
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: const BorderSide(color: Colors.black),
            ),
            elevation: 0,
          ),
          onPressed: () async {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => const Center(child: CircularProgressIndicator()),
            );
            try {
              bool restorationSuccess = await subscriptionsProvider.initializeSubscriptions();
              Navigator.of(context, rootNavigator: true).pop();
              if (!restorationSuccess &&
                  !subscriptionsProvider.hasCompleteActiveSubscription &&
                  !subscriptionsProvider.hasCompletePlusSimpleCalculationProductId) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('No active subscriptions found. Please purchase a subscription.')),
                );
              }
            } catch (e) {
              Navigator.of(context, rootNavigator: true).pop();
              _showErrorDialog(context, e.toString());
            }
          },
          child: const Text(
            'Restore Purchases',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
      ),
      const SizedBox(height: 20),
      // Privacy Policy and Terms of Use links
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () => _launchUrl(context, 'https://www.termsfeed.com/live/228b3ef3-78b7-4838-a02a-77fb59345193'),
            child: const Text(
              'Privacy Policy',
              style: TextStyle(
                fontSize: 16,
                color: Colors.blue,
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          const SizedBox(width: 16),
          TextButton(
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () => _launchUrl(context, 'https://www.apple.com/legal/internet-services/itunes/us/terms.html'),
            child: const Text(
              'Terms of Use',
              style: TextStyle(
                fontSize: 16,
                color: Colors.blue,
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 20),
    ];

    await showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text(
          'Choose a Subscription',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        contentPadding: const EdgeInsets.all(16.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: Colors.white,
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: subscriptionTiles,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }*/

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

