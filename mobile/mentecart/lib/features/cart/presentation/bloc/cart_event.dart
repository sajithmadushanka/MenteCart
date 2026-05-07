import 'package:equatable/equatable.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

class CartFetched extends CartEvent {}

class CartItemAdded extends CartEvent {
  final String serviceId;

  final String selectedDate;

  final String selectedTimeSlot;

  final int quantity;

  const CartItemAdded({
    required this.serviceId,
    required this.selectedDate,
    required this.selectedTimeSlot,
    required this.quantity,
  });

  @override
  List<Object?> get props => [
    serviceId,
    selectedDate,
    selectedTimeSlot,
    quantity,
  ];
}

class CartItemRemoved extends CartEvent {
  final String itemId;

  const CartItemRemoved(this.itemId);

  @override
  List<Object?> get props => [itemId];
}

class CartItemUpdated extends CartEvent {
  final String itemId;

  final int quantity;

  const CartItemUpdated({required this.itemId, required this.quantity});

  @override
  List<Object?> get props => [itemId, quantity];
}
