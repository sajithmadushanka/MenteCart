import 'cart_item_model.dart';

class CartModel {
  final String id;

  final List<CartItemModel> items;

  final int totalItems;

  final double totalAmount;

  CartModel({
    required this.id,
    required this.items,
    required this.totalItems,
    required this.totalAmount,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      id: json['id'],

      items: (json['items'] as List)
          .map((item) => CartItemModel.fromJson(item))
          .toList(),

      totalItems: json['totalItems'],

      totalAmount: (json['totalAmount'] as num).toDouble(),
    );
  }
}
