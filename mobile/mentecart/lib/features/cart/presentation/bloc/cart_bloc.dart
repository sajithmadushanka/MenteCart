import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentecart/app/errors/api_error_handler.dart';

import '../../domain/repositories/cart_repository.dart';

import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository cartRepository;

  CartBloc({required this.cartRepository}) : super(CartInitial()) {
    on<CartFetched>(_onCartFetched);

    on<CartItemAdded>(_onCartItemAdded);

    on<CartItemRemoved>(_onCartItemRemoved);

    on<CartItemUpdated>(_onCartItemUpdated);
  }

  Future<void> _onCartFetched(
    CartFetched event,
    Emitter<CartState> emit,
  ) async {
    try {
      final cart = await cartRepository.getCart();

      emit(CartLoaded(cart));
    } catch (e) {
      emit(CartFailure(ApiErrorHandler.getMessage(e)));
    }
  }

  Future<void> _onCartItemAdded(
    CartItemAdded event,
    Emitter<CartState> emit,
  ) async {
    try {
      await cartRepository.addToCart(
        serviceId: event.serviceId,

        selectedDate: event.selectedDate,

        selectedTimeSlot: event.selectedTimeSlot,

        quantity: event.quantity,
      );

      emit(const CartActionSuccess('Added to cart'));

      add(CartFetched());
    } catch (e) {
      emit(CartActionSuccess(ApiErrorHandler.getMessage(e)));
    }
  }

  Future<void> _onCartItemRemoved(
    CartItemRemoved event,
    Emitter<CartState> emit,
  ) async {
    try {
      await cartRepository.removeCartItem(event.itemId);

      add(CartFetched());
    } catch (e) {
      emit(CartActionFailure(ApiErrorHandler.getMessage(e)));

      add(CartFetched());
    }
  }

  Future<void> _onCartItemUpdated(
    CartItemUpdated event,
    Emitter<CartState> emit,
  ) async {
    try {
      await cartRepository.updateCartItem(
        itemId: event.itemId,

        quantity: event.quantity,
      );

      add(CartFetched());
    } catch (e) {
      emit(CartActionFailure(ApiErrorHandler.getMessage(e)));

      add(CartFetched());
    }
  }
}
