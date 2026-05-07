import 'package:mentecart/features/bookings/data/datasources/bookings_remote_datasource.dart';
import 'package:mentecart/features/bookings/domain/repositories/bookings_repository.dart';

import '../models/booking_model.dart';

class BookingsRepositoryImpl implements BookingsRepository {
  final BookingsRemoteDatasource remoteDatasource;

  BookingsRepositoryImpl({required this.remoteDatasource});

  @override
  Future<BookingModel> checkout({required String paymentMethod}) {
    return remoteDatasource.checkout(paymentMethod: paymentMethod);
  }

  @override
  Future<List<BookingModel>> getBookings() {
    return remoteDatasource.getBookings();
  }

  @override
  Future<BookingModel> getBookingById(String bookingId) {
    return remoteDatasource.getBookingById(bookingId);
  }

  @override
  Future<Map<String, dynamic>> initializePayHerePayment(String bookingId) {
    return remoteDatasource.initializePayHerePayment(bookingId);
  }

  @override
  Future<void> cancelBooking(String bookingId) {
    return remoteDatasource.cancelBooking(bookingId);
  }
}
