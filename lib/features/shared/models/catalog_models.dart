import 'package:flutter/material.dart';

@immutable
class HotelListItem {
  final String id;
  final String name;
  final String city;
  final String location;
  final String image;
  final double rating;
  final int reviewCount;
  final double price;
  final List<String> amenities;
  final int stars;

  const HotelListItem({
    required this.id,
    required this.name,
    required this.city,
    required this.location,
    required this.image,
    required this.rating,
    required this.reviewCount,
    required this.price,
    this.amenities = const <String>[],
    required this.stars,
  });
}

@immutable
class TourListItem {
  final String id;
  final String name;
  final String category;
  final String duration;
  final String image;
  final double rating;
  final int reviewCount;
  final double price;
  final bool pickupIncluded;

  const TourListItem({
    required this.id,
    required this.name,
    required this.category,
    required this.duration,
    required this.image,
    required this.rating,
    required this.reviewCount,
    required this.price,
    required this.pickupIncluded,
  });
}

@immutable
class CarListItem {
  final String id;
  final String name;
  final String type;
  final String image;
  final int seats;
  final String transmission;
  final double rating;
  final int reviewCount;
  final double price;
  final bool withDriver;
  final int driverPrice;

  const CarListItem({
    required this.id,
    required this.name,
    required this.type,
    required this.image,
    required this.seats,
    required this.transmission,
    required this.rating,
    required this.reviewCount,
    required this.price,
    required this.withDriver,
    required this.driverPrice,
  });
}

@immutable
class DestinationItem {
  final String name;
  final String image;

  const DestinationItem({required this.name, required this.image});
}

@immutable
class HomeCategoryItem {
  final IconData icon;
  final String label;
  final String route;

  const HomeCategoryItem({
    required this.icon,
    required this.label,
    required this.route,
  });
}
