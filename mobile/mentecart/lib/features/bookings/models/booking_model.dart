import 'booking_item_model.dart';

class BookingModel {
  final String id;

  final String bookingNumber;

  final List<BookingItemModel> items;

  final int totalItems;

  final double totalAmount;

  final String status;

  final String paymentMethod;

  final String paymentStatus;

  final String? transactionId;

  final DateTime? paidAt;

  final DateTime bookedAt;

  BookingModel({
    required this.id,
    required this.bookingNumber,
    required this.items,
    required this.totalItems,
    required this.totalAmount,
    required this.status,
    required this.paymentMethod,
    required this.paymentStatus,
    this.transactionId,
    this.paidAt,
    required this.bookedAt,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'],

      bookingNumber: json['bookingNumber'],

      items: (json['items'] as List)
          .map((item) => BookingItemModel.fromJson(item))
          .toList(),

      totalItems: json['totalItems'],

      totalAmount: (json['totalAmount'] as num).toDouble(),

      status: json['status'],

      paymentMethod: json['paymentMethod'],

      paymentStatus: json['paymentStatus'],

      transactionId: json['transactionId'],

      paidAt: json['paidAt'] != null ? DateTime.parse(json['paidAt']) : null,

      bookedAt: DateTime.parse(json['bookedAt']),
    );
  }
}
