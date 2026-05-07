import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentecart/app/errors/api_error_handler.dart';

import '../../domain/repositories/bookings_repository.dart';

import 'bookings_event.dart';

import 'bookings_state.dart';

class BookingsBloc extends Bloc<BookingsEvent, BookingsState> {
  final BookingsRepository bookingsRepository;

  BookingsBloc({required this.bookingsRepository}) : super(BookingsInitial()) {
    on<BookingsFetched>(_onBookingsFetched);

    on<BookingDetailsFetched>(_onBookingDetailsFetched);

    on<BookingCancelled>(_onBookingCancelled);
  }

  Future<void> _onBookingsFetched(
    BookingsFetched event,
    Emitter<BookingsState> emit,
  ) async {
    try {
      emit(BookingsLoading());

      final bookings = await bookingsRepository.getBookings();

      emit(BookingsLoaded(bookings));
    } catch (e) {
      emit(BookingsFailure(e.toString()));
    }
  }

  Future<void> _onBookingDetailsFetched(
    BookingDetailsFetched event,
    Emitter<BookingsState> emit,
  ) async {
    try {
      emit(BookingsLoading());

      final booking = await bookingsRepository.getBookingById(event.bookingId);

      emit(BookingDetailsLoaded(booking));
    } catch (e) {
      emit(BookingsFailure(e.toString()));
    }
  }

  Future<void> _onBookingCancelled(
    BookingCancelled event,
    Emitter<BookingsState> emit,
  ) async {
    try {
      await bookingsRepository.cancelBooking(event.bookingId);

      add(BookingsFetched());
    } catch (e) {
      emit(BookingsFailure(ApiErrorHandler.getMessage(e)));
    }
  }
}
