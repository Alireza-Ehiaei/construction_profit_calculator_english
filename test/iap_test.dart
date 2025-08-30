import 'package:flutter_test/flutter_test.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'iap_test.mocks.dart';

@GenerateMocks([InAppPurchase])
void main() {
  late MockInAppPurchase mockInAppPurchase;

  setUp(() {
    mockInAppPurchase = MockInAppPurchase();
  });

  test('Fetch products successfully', () async {
    final productDetailsResponse = ProductDetailsResponse(
      productDetails: [
        ProductDetails(
          id: 'test_product',
          title: 'Test Product',
          description: 'A test product',
          price: '\$0.99',
          rawPrice: 0.99,
          currencyCode: 'USD',
        ),
      ],
      notFoundIDs: [],
    );

    when(mockInAppPurchase.queryProductDetails({'test_product'})).thenAnswer(
      (_) async => productDetailsResponse,
    );

    final response = await mockInAppPurchase.queryProductDetails({'test_product'});

    expect(response.productDetails.length, 1);
    expect(response.productDetails.first.id, 'test_product');
  });
}
