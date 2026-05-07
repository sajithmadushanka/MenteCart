import 'package:mentecart/features/cart/data/datasources/cart_remote_datasource.dart';
import 'package:mentecart/features/cart/domain/repositories/cart_repository.dart';

import '../models/cart_model.dart';

class CartRepositoryImpl implements CartRepository {
  final CartRemoteDatasource remoteDatasource;

  CartRepositoryImpl({required this.remoteDatasource});

  @override
  Future<CartModel> getCart() {
    return remoteDatasource.getCart();
  }

  @override
  Future<void> addToCart({
    required String serviceId,
    required String selectedDate,
    required String selectedTimeSlot,
    required int quantity,
  }) {
    return remoteDatasource.addToCart(
      serviceId: serviceId,
      selectedDate: selectedDate,
      selectedTimeSlot: selectedTimeSlot,
      quantity: quantity,
    );
  }

  @override
  Future<void> removeCartItem(String itemId) {
    return remoteDatasource.removeCartItem(itemId);
  }

  @override
  Future<void> updateCartItem({required String itemId, required int quantity}) {
    return remoteDatasource.updateCartItem(itemId: itemId, quantity: quantity);
  }
}
