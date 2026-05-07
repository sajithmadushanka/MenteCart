class BookingItemModel {
  final String id;

  final String serviceId;

  final String title;

  final String imageUrl;

  final int duration;

  final String selectedDate;

  final String selectedTimeSlot;

  final int quantity;

  final double unitPrice;

  final double subtotal;

  BookingItemModel({
    required this.id,
    required this.serviceId,
    required this.title,
    required this.imageUrl,
    required this.duration,
    required this.selectedDate,
    required this.selectedTimeSlot,
    required this.quantity,
    required this.unitPrice,
    required this.subtotal,
  });

  factory BookingItemModel.fromJson(Map<String, dynamic> json) {
    final snapshot = json['serviceSnapshot'];

    return BookingItemModel(
      id: json['id'],

      serviceId: json['serviceId'],

      title: snapshot['title'],

      imageUrl: snapshot['imageUrl'],

      duration: snapshot['duration'],

      selectedDate: json['selectedDate'],

      selectedTimeSlot: json['selectedTimeSlot'],

      quantity: json['quantity'],

      unitPrice: (json['unitPrice'] as num).toDouble(),

      subtotal: (json['subtotal'] as num).toDouble(),
    );
  }
}
