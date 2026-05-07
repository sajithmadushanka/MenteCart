import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentecart/app/errors/api_error_handler.dart';

import '../../domain/repositories/bookings_repository.dart';

import 'checkout_event.dart';

import 'checkout_state.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  final BookingsRepository bookingsRepository;

  CheckoutBloc({required this.bookingsRepository}) : super(CheckoutInitial()) {
    on<CheckoutStarted>(_onCheckoutStarted);
  }

  Future<void> _onCheckoutStarted(
    CheckoutStarted event,
    Emitter<CheckoutState> emit,
  ) async {
    try {
      emit(CheckoutLoading());

      final booking = await bookingsRepository.checkout(
        paymentMethod: event.paymentMethod,
      );

      emit(CheckoutSuccess(booking: booking));
    } catch (e) {
      emit(CheckoutFailure(ApiErrorHandler.getMessage(e)));
    }
  }
}
