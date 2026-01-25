import 'package:cloud_firestore/cloud_firestore.dart';

class RestaurantModel {
  final String id;
  final String name;
  final String description;
  final String address;
  final String city;
  final double latitude;
  final double longitude;
  final List<String> images;
  final double rating;
  final int reviewCount;
  final String priceRange; // $, $$, $$$
  final List<String> cuisineTypes;
  final String openingHours;
  final String closingHours;
  final bool isOpen;
  final String phoneNumber;
  final bool hasDelivery;
  final bool hasPickup;
  final bool hasDineIn;
  final double deliveryFee;
  final int deliveryTimeMinutes;
  final String ownerId;
  final DateTime createdAt;

  RestaurantModel({
    required this.id,
    required this.name,
    required this.description,
    required this.address,
    required this.city,
    required this.latitude,
    required this.longitude,
    required this.images,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.priceRange = '\$\$',
    this.cuisineTypes = const [],
    this.openingHours = '10:00',
    this.closingHours = '22:00',
    this.isOpen = true,
    this.phoneNumber = '',
    this.hasDelivery = true,
    this.hasPickup = true,
    this.hasDineIn = true,
    this.deliveryFee = 0.0,
    this.deliveryTimeMinutes = 30,
    required this.ownerId,
    required this.createdAt,
  });

  factory RestaurantModel.fromJson(Map<String, dynamic> json) {
    return RestaurantModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
      images: List<String>.from(json['images'] ?? []),
      rating: (json['rating'] ?? 0).toDouble(),
      reviewCount: json['reviewCount'] ?? 0,
      priceRange: json['priceRange'] ?? '\$\$',
      cuisineTypes: List<String>.from(json['cuisineTypes'] ?? []),
      openingHours: json['openingHours'] ?? '10:00',
      closingHours: json['closingHours'] ?? '22:00',
      isOpen: json['isOpen'] ?? true,
      phoneNumber: json['phoneNumber'] ?? '',
      hasDelivery: json['hasDelivery'] ?? true,
      hasPickup: json['hasPickup'] ?? true,
      hasDineIn: json['hasDineIn'] ?? true,
      deliveryFee: (json['deliveryFee'] ?? 0).toDouble(),
      deliveryTimeMinutes: json['deliveryTimeMinutes'] ?? 30,
      ownerId: json['ownerId'] ?? '',
      createdAt: json['createdAt'] is Timestamp
          ? (json['createdAt'] as Timestamp).toDate()
          : DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'address': address,
      'city': city,
      'latitude': latitude,
      'longitude': longitude,
      'images': images,
      'rating': rating,
      'reviewCount': reviewCount,
      'priceRange': priceRange,
      'cuisineTypes': cuisineTypes,
      'openingHours': openingHours,
      'closingHours': closingHours,
      'isOpen': isOpen,
      'phoneNumber': phoneNumber,
      'hasDelivery': hasDelivery,
      'hasPickup': hasPickup,
      'hasDineIn': hasDineIn,
      'deliveryFee': deliveryFee,
      'deliveryTimeMinutes': deliveryTimeMinutes,
      'ownerId': ownerId,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  String get mainImage => images.isNotEmpty ? images.first : '';
  String get formattedRating => rating.toStringAsFixed(1);
}