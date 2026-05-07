import 'package:mentecart/features/bookings/models/booking_model.dart';

import '../../../../app/network/api_client.dart';

class BookingsRemoteDatasource {
  final ApiClient apiClient;

  BookingsRemoteDatasource({required this.apiClient});

  Future<BookingModel> checkout({required String paymentMethod}) async {
    final response = await apiClient.post(
      '/bookings/checkout',
      data: {'paymentMethod': paymentMethod},
    );

    return BookingModel.fromJson(response.data['data']);
  }

  Future<List<BookingModel>> getBookings() async {
    final response = await apiClient.get('/bookings');

    final List bookings = response.data['data'];

    return bookings.map((booking) => BookingModel.fromJson(booking)).toList();
  }

  Future<BookingModel> getBookingById(String bookingId) async {
    final response = await apiClient.get('/bookings/$bookingId');

    return BookingModel.fromJson(response.data['data']);
  }

  Future<Map<String, dynamic>> initializePayHerePayment(
    String bookingId,
  ) async {
    final response = await apiClient.get('/payments/payhere/$bookingId');

    return response.data['data'];
  }

  Future<void> cancelBooking(String bookingId) async {
    await apiClient.patch('/bookings/$bookingId/cancel');
  }
}
