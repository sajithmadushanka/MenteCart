import 'package:equatable/equatable.dart';
import 'package:mentecart/features/cart/models/cart_model.dart';

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final CartModel cart;

  const CartLoaded(this.cart);

  @override
  List<Object?> get props => [cart];
}

class CartFailure extends CartState {
  final String message;

  const CartFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class CartActionSuccess extends CartState {
  final String message;

  const CartActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class CartActionFailure extends CartState {
  final String message;

  const CartActionFailure(this.message);

  @override
  List<Object?> get props => [message];
}
