import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/image_urls.dart';

final hotelsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  await Future<void>.delayed(const Duration(milliseconds: 300));
  return const [
    {
      'id': '1',
      'name': 'Pyramids View Hotel',
      'city': 'Cairo',
      'location': 'Giza, Cairo',
      'image': Img.hotelLuxury,
      'rating': 4.8,
      'reviewCount': 520,
      'price': 120.0,
      'amenities': ['WiFi', 'Pool', 'Restaurant', 'Spa'],
      'stars': 5,
    },
    {
      'id': '2',
      'name': 'Nile Ritz Carlton',
      'city': 'Cairo',
      'location': 'Downtown Cairo',
      'image': Img.hotelPool,
      'rating': 4.9,
      'reviewCount': 890,
      'price': 250.0,
      'amenities': ['WiFi', 'Pool', 'Gym', 'Restaurant'],
      'stars': 5,
    },
    {
      'id': '3',
      'name': 'Steigenberger Resort',
      'city': 'Hurghada',
      'location': 'Hurghada',
      'image': Img.hotelResort,
      'rating': 4.7,
      'reviewCount': 430,
      'price': 180.0,
      'amenities': ['WiFi', 'Beach', 'Pool', 'Spa'],
      'stars': 5,
    },
    {
      'id': '4',
      'name': 'Hilton Luxor Resort',
      'city': 'Luxor',
      'location': 'Luxor City',
      'image': Img.hotelRoom,
      'rating': 4.6,
      'reviewCount': 350,
      'price': 140.0,
      'amenities': ['WiFi', 'Pool', 'Restaurant'],
      'stars': 4,
    },
    {
      'id': '5',
      'name': 'Four Seasons Alexandria',
      'city': 'Alexandria',
      'location': 'Alexandria Corniche',
      'image': Img.hotelLobby,
      'rating': 4.9,
      'reviewCount': 670,
      'price': 300.0,
      'amenities': ['WiFi', 'Beach', 'Spa', 'Pool'],
      'stars': 5,
    },
  ];
});
