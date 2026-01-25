import 'package:cloud_firestore/cloud_firestore.dart';

class HotelModel {
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
  final double pricePerNight;
  final String currency;
  final List<String> amenities;
  final int starRating;
  final bool isAvailable;
  final String ownerId;
  final DateTime createdAt;

  HotelModel({
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
    required this.pricePerNight,
    this.currency = 'USD',
    this.amenities = const [],
    this.starRating = 3,
    this.isAvailable = true,
    required this.ownerId,
    required this.createdAt,
  });

  factory HotelModel.fromJson(Map<String, dynamic> json) {
    return HotelModel(
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
      pricePerNight: (json['pricePerNight'] ?? 0).toDouble(),
      currency: json['currency'] ?? 'USD',
      amenities: List<String>.from(json['amenities'] ?? []),
      starRating: json['starRating'] ?? 3,
      isAvailable: json['isAvailable'] ?? true,
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
      'pricePerNight': pricePerNight,
      'currency': currency,
      'amenities': amenities,
      'starRating': starRating,
      'isAvailable': isAvailable,
      'ownerId': ownerId,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  String get formattedPrice => '\$$pricePerNight/night';
  String get formattedRating => rating.toStringAsFixed(1);
  String get mainImage => images.isNotEmpty ? images.first : '';
}