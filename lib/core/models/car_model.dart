import 'package:cloud_firestore/cloud_firestore.dart';

class CarModel {
  final String id;
  final String name;
  final String brand;
  final String model;
  final int year;
  final String type; // sedan, suv, van, luxury
  final String description;
  final List<String> images;
  final double rating;
  final int reviewCount;
  final double pricePerDay;
  final String currency;
  final int seats;
  final String transmission; // automatic, manual
  final String fuelType; // petrol, diesel, electric, hybrid
  final List<String> features;
  final bool withDriver;
  final double driverPricePerDay;
  final bool isAvailable;
  final String ownerId;
  final String city;
  final DateTime createdAt;

  CarModel({
    required this.id,
    required this.name,
    required this.brand,
    required this.model,
    required this.year,
    required this.type,
    required this.description,
    required this.images,
    this.rating = 0.0,
    this.reviewCount = 0,
    required this.pricePerDay,
    this.currency = 'USD',
    required this.seats,
    this.transmission = 'automatic',
    this.fuelType = 'petrol',
    this.features = const [],
    this.withDriver = false,
    this.driverPricePerDay = 0.0,
    this.isAvailable = true,
    required this.ownerId,
    required this.city,
    required this.createdAt,
  });

  factory CarModel.fromJson(Map<String, dynamic> json) {
    return CarModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      brand: json['brand'] ?? '',
      model: json['model'] ?? '',
      year: json['year'] ?? 2020,
      type: json['type'] ?? 'sedan',
      description: json['description'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      rating: (json['rating'] ?? 0).toDouble(),
      reviewCount: json['reviewCount'] ?? 0,
      pricePerDay: (json['pricePerDay'] ?? 0).toDouble(),
      currency: json['currency'] ?? 'USD',
      seats: json['seats'] ?? 5,
      transmission: json['transmission'] ?? 'automatic',
      fuelType: json['fuelType'] ?? 'petrol',
      features: List<String>.from(json['features'] ?? []),
      withDriver: json['withDriver'] ?? false,
      driverPricePerDay: (json['driverPricePerDay'] ?? 0).toDouble(),
      isAvailable: json['isAvailable'] ?? true,
      ownerId: json['ownerId'] ?? '',
      city: json['city'] ?? '',
      createdAt: json['createdAt'] is Timestamp
          ? (json['createdAt'] as Timestamp).toDate()
          : DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'brand': brand,
      'model': model,
      'year': year,
      'type': type,
      'description': description,
      'images': images,
      'rating': rating,
      'reviewCount': reviewCount,
      'pricePerDay': pricePerDay,
      'currency': currency,
      'seats': seats,
      'transmission': transmission,
      'fuelType': fuelType,
      'features': features,
      'withDriver': withDriver,
      'driverPricePerDay': driverPricePerDay,
      'isAvailable': isAvailable,
      'ownerId': ownerId,
      'city': city,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  String get formattedPrice => '\$$pricePerDay/day';
  String get mainImage => images.isNotEmpty ? images.first : '';
}