import 'package:equatable/equatable.dart';

import '../../models/booking_model.dart';

abstract class BookingsState extends Equatable {
  const BookingsState();

  @override
  List<Object?> get props => [];
}

class BookingsInitial extends BookingsState {}

class BookingsLoading extends BookingsState {}

class BookingsLoaded extends BookingsState {
  final List<BookingModel> bookings;

  const BookingsLoaded(this.bookings);

  @override
  List<Object?> get props => [bookings];
}

class BookingDetailsLoaded extends BookingsState {
  final BookingModel booking;

  const BookingDetailsLoaded(this.booking);

  @override
  List<Object?> get props => [booking];
}

class BookingsFailure extends BookingsState {
  final String message;

  const BookingsFailure(this.message);

  @override
  List<Object?> get props => [message];
}
