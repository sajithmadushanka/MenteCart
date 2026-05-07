import 'package:equatable/equatable.dart';

abstract class BookingsEvent extends Equatable {
  const BookingsEvent();

  @override
  List<Object?> get props => [];
}

class BookingsFetched extends BookingsEvent {}

class BookingDetailsFetched extends BookingsEvent {
  final String bookingId;

  const BookingDetailsFetched(this.bookingId);

  @override
  List<Object?> get props => [bookingId];
}

class BookingCancelled extends BookingsEvent {
  final String bookingId;

  const BookingCancelled(this.bookingId);

  @override
  List<Object?> get props => [bookingId];
}
