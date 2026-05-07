import 'package:mentecart/features/cart/models/cart_model.dart';

import '../../../../app/network/api_client.dart';

class CartRemoteDatasource {
  final ApiClient apiClient;

  CartRemoteDatasource({required this.apiClient});

  Future<CartModel> getCart() async {
    final response = await apiClient.get('/cart');

    return CartModel.fromJson(response.data['data']);
  }

  Future<void> addToCart({
    required String serviceId,
    required String selectedDate,
    required String selectedTimeSlot,
    required int quantity,
  }) async {
    await apiClient.post(
      '/cart/items',
      data: {
        'serviceId': serviceId,
        'selectedDate': selectedDate,
        'selectedTimeSlot': selectedTimeSlot,
        'quantity': quantity,
      },
    );
  }

  Future<void> removeCartItem(String itemId) async {
    await apiClient.delete('/cart/items/$itemId');
  }

  Future<void> updateCartItem({
    required String itemId,
    required int quantity,
  }) async {
    await apiClient.patch('/cart/items/$itemId', data: {'quantity': quantity});
  }
}
