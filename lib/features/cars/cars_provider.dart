import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/image_urls.dart';

final carsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  await Future<void>.delayed(const Duration(milliseconds: 300));
  return const [
    {
      'id': '1',
      'name': 'Toyota Camry 2023',
      'type': 'Sedan',
      'image': Img.carSedan,
      'seats': 5,
      'transmission': 'Automatic',
      'rating': 4.8,
      'reviewCount': 245,
      'price': 45.0,
      'withDriver': true,
      'driverPrice': 25,
    },
    {
      'id': '2',
      'name': 'BMW X5',
      'type': 'SUV',
      'image': Img.carSuv,
      'seats': 7,
      'transmission': 'Automatic',
      'rating': 4.9,
      'reviewCount': 189,
      'price': 85.0,
      'withDriver': true,
      'driverPrice': 35,
    },
    {
      'id': '3',
      'name': 'Mercedes C-Class',
      'type': 'Luxury',
      'image': Img.carLuxury,
      'seats': 5,
      'transmission': 'Automatic',
      'rating': 4.9,
      'reviewCount': 156,
      'price': 120.0,
      'withDriver': true,
      'driverPrice': 45,
    },
    {
      'id': '4',
      'name': 'Hyundai Staria',
      'type': 'Van',
      'image': Img.carVan,
      'seats': 8,
      'transmission': 'Automatic',
      'rating': 4.7,
      'reviewCount': 320,
      'price': 70.0,
      'withDriver': false,
      'driverPrice': 0,
    },
  ];
});
