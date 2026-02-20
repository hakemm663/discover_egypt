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
      'image': Img.koshari,
      'rating': 4.7,
      'reviewCount': 2100,
      'priceRange': r'$4-$10',
      'deliveryTime': 30,
      'delivery': true,
    },
    {
      'id': '2',
      'name': 'Sequoia',
      'cuisine': 'Mediterranean',
      'location': 'Zamalek, Cairo',
      'image': Img.restaurant,
      'rating': 4.8,
      'reviewCount': 1400,
      'priceRange': r'$30-$60',
      'deliveryTime': 45,
      'delivery': true,
    },
    {
      'id': '3',
      'name': 'Felfela Restaurant',
      'cuisine': 'Egyptian',
      'location': 'Downtown Cairo',
      'image': Img.egyptianFood,
      'rating': 4.5,
      'reviewCount': 980,
      'priceRange': r'$8-$20',
      'deliveryTime': 25,
      'delivery': false,
    },
    {
      'id': '4',
      'name': 'Kazoku',
      'cuisine': 'Asian',
      'location': 'New Cairo',
      'image': Img.restaurantInterior,
      'rating': 4.9,
      'reviewCount': 760,
      'priceRange': r'$40-$80',
      'deliveryTime': 40,
      'delivery': true,
    },
  ];
});
