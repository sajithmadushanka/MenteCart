class ServiceModel {
  final String id;

  final String title;

  final String description;

  final double price;

  final int duration;

  final String category;

  final String imageUrl;

  final int capacityPerSlot;

  final bool isActive;

  ServiceModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.duration,
    required this.category,
    required this.imageUrl,
    required this.capacityPerSlot,
    required this.isActive,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'],

      title: json['title'],

      description: json['description'],

      price: (json['price'] as num).toDouble(),

      duration: json['duration'],

      category: json['category'],

      imageUrl: json['imageUrl'],

      capacityPerSlot: json['capacityPerSlot'],

      isActive: json['isActive'],
    );
  }
}
