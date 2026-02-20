import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/image_urls.dart';

final restaurantsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  await Future<void>.delayed(const Duration(milliseconds: 300));
  return const [
    {
      'id': '1',
      'name': 'Koshary Abou Tarek',
      'cuisine': 'Egyptian',
      'location': 'Downtown Cairo',
      'image': Img.koshary,
      'rating': 4.7,
      'reviewCount': 2100,
      'priceRange': '$4-$10',
      'deliveryTime': 30,
      'delivery': true,
    },
    {
      'id': '2',
      'name': 'Sequoia',
      'cuisine': 'Mediterranean',
      'location': 'Zamalek, Cairo',
      'image': Img.sequoia,
      'rating': 4.8,
      'reviewCount': 1400,
      'priceRange': '$30-$60',
      'deliveryTime': 45,
      'delivery': true,
    },
    {
      'id': '3',
      'name': 'Felfela Restaurant',
      'cuisine': 'Egyptian',
      'location': 'Downtown Cairo',
      'image': Img.felfela,
      'rating': 4.5,
      'reviewCount': 980,
      'priceRange': '$8-$20',
      'deliveryTime': 25,
      'delivery': false,
    },
    {
      'id': '4',
      'name': 'Kazoku',
      'cuisine': 'Asian',
      'location': 'New Cairo',
      'image': Img.kazoku,
      'rating': 4.9,
      'reviewCount': 760,
      'priceRange': '$40-$80',
      'deliveryTime': 40,
      'delivery': true,
    },
  ];
});
