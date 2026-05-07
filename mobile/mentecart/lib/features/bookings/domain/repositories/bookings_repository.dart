import 'package:mentecart/features/bookings/models/booking_model.dart';

abstract class BookingsRepository {
  Future<BookingModel> checkout({required String paymentMethod});

  Future<List<BookingModel>> getBookings();

  Future<BookingModel> getBookingById(String bookingId);

  Future<Map<String, dynamic>> initializePayHerePayment(String bookingId);

  Future<void> cancelBooking(String bookingId);
}
