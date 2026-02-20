import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/image_urls.dart';

final myBookingsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  await Future<void>.delayed(const Duration(milliseconds: 300));
  return const [
    {
      'id': '1',
      'type': 'Hotel',
      'name': 'Pyramids View Hotel',
      'image': Img.hotelLuxury,
      'date': 'Apr 20 - Apr 24, 2024',
      'status': 'Confirmed',
      'amount': 410.40,
    },
    {
      'id': '2',
      'type': 'Tour',
      'name': 'Nile Cruise & Giza Tour',
      'image': Img.nileCruise,
      'date': 'Apr 25, 2024',
      'status': 'Confirmed',
      'amount': 65.00,
    },
    {
      'id': '3',
      'type': 'Hotel',
      'name': 'Nile Ritz Carlton',
      'image': Img.hotelPool,
      'date': 'Mar 10 - Mar 15, 2024',
      'status': 'Completed',
      'amount': 1250.00,
    },
  ];
});
