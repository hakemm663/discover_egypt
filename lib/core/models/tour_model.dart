import 'package:cloud_firestore/cloud_firestore.dart';

class TourModel {
  final String id;
  final String name;
  final String description;
  final String shortDescription;
  final String location;
  final String city;
  final double latitude;
  final double longitude;
  final List<String> images;
  final double rating;
  final int reviewCount;
  final double price;
  final String currency;
  final String duration;
  final List<String> includes;
  final List<String> excludes;
  final List<String> highlights;
  final String meetingPoint;
  final String startTime;
  final int maxGroupSize;
  final bool isPrivate;
  final bool pickupIncluded;
  final bool isAvailable;
  final String ownerId;
  final DateTime createdAt;

  TourModel({
    required this.id,
    required this.name,
    required this.description,
    this.shortDescription = '',
    required this.location,
    required this.city,
    required this.latitude,
    required this.longitude,
    required this.images,
    this.rating = 0.0,
    this.reviewCount = 0,
    required this.price,
    this.currency = 'USD',
    required this.duration,
    this.includes = const [],
    this.excludes = const [],
    this.highlights = const [],
    this.meetingPoint = '',
    this.startTime = '09:00',
    this.maxGroupSize = 15,
    this.isPrivate = false,
    this.pickupIncluded = true,
    this.isAvailable = true,
    required this.ownerId,
    required this.createdAt,
  });

  factory TourModel.fromJson(Map<String, dynamic> json) {
    return TourModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      shortDescription: json['shortDescription'] ?? '',
      location: json['location'] ?? '',
      city: json['city'] ?? '',
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
      images: List<String>.from(json['images'] ?? []),
      rating: (json['rating'] ?? 0).toDouble(),
      reviewCount: json['reviewCount'] ?? 0,
      price: (json['price'] ?? 0).toDouble(),
      currency: json['currency'] ?? 'USD',
      duration: json['duration'] ?? '',
      includes: List<String>.from(json['includes'] ?? []),
      excludes: List<String>.from(json['excludes'] ?? []),
      highlights: List<String>.from(json['highlights'] ?? []),
      meetingPoint: json['meetingPoint'] ?? '',
      startTime: json['startTime'] ?? '09:00',
      maxGroupSize: json['maxGroupSize'] ?? 15,
      isPrivate: json['isPrivate'] ?? false,
      pickupIncluded: json['pickupIncluded'] ?? true,
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
      'shortDescription': shortDescription,
      'location': location,
      'city': city,
      'latitude': latitude,
      'longitude': longitude,
      'images': images,
      'rating': rating,
      'reviewCount': reviewCount,
      'price': price,
      'currency': currency,
      'duration': duration,
      'includes': includes,
      'excludes': excludes,
      'highlights': highlights,
      'meetingPoint': meetingPoint,
      'startTime': startTime,
      'maxGroupSize': maxGroupSize,
      'isPrivate': isPrivate,
      'pickupIncluded': pickupIncluded,
      'isAvailable': isAvailable,
      'ownerId': ownerId,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  String get formattedPrice => '\$$price';
  String get formattedRating => rating.toStringAsFixed(1);
  String get mainImage => images.isNotEmpty ? images.first : '';
}