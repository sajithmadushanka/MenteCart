import 'package:equatable/equatable.dart';

abstract class CheckoutEvent
    extends Equatable {
  const CheckoutEvent();

  @override
  List<Object?> get props => [];
}

class CheckoutStarted
    extends CheckoutEvent {
  final String paymentMethod;

  const CheckoutStarted(
    this.paymentMethod,
  );

  @override
  List<Object?> get props => [
        paymentMethod,
      ];
}