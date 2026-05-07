import 'package:mentecart/features/cart/models/cart_model.dart';

abstract class CartRepository {
  Future<CartModel> getCart();

  Future<void> addToCart({
    required String serviceId,
    required String selectedDate,
    required String selectedTimeSlot,
    required int quantity,
  });

  Future<void> removeCartItem(String itemId);

  Future<void> updateCartItem({required String itemId, required int quantity});
}
