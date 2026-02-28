import '../models/pagination_models.dart';

Map<String, dynamic> hotelsFallbackPayload(PaginationQuery query) {
  return _buildPayload(_hotelsCatalog, query);
}

Map<String, dynamic> toursFallbackPayload(PaginationQuery query) {
  return _buildPayload(_toursCatalog, query);
}

Map<String, dynamic> carsFallbackPayload(PaginationQuery query) {
  return _buildPayload(_carsCatalog, query);
}

Map<String, dynamic> restaurantsFallbackPayload(PaginationQuery query) {
  return _buildPayload(_restaurantsCatalog, query);
}

Map<String, dynamic> _buildPayload(List<Map<String, dynamic>> catalog, PaginationQuery query) {
  final start = query.offset;
  final end = (start + query.pageSize).clamp(0, catalog.length);
  final items = start >= catalog.length
      ? const <Map<String, dynamic>>[]
      : catalog.sublist(start, end).map((item) => Map<String, dynamic>.from(item)).toList(growable: false);

  return {
    'items': items,
    'meta': {
      'page': query.page,
      'pageSize': query.pageSize,
      'totalCount': catalog.length,
    },
  };
}

const List<Map<String, dynamic>> _hotelsCatalog = [
  {
    'id': 'fallback-hotel-1',
    'name': 'Nile View Suites',
    'city': 'Cairo',
    'location': 'Downtown Cairo',
    'image': 'https://images.unsplash.com/photo-1566073771259-6a8506099945',
    'rating': 4.6,
    'reviewCount': 320,
    'price': 145.0,
    'stars': 4,
    'amenities': ['WiFi', 'Pool', 'Breakfast'],
  },
  {
    'id': 'fallback-hotel-2',
    'name': 'Luxor Palace Hotel',
    'city': 'Luxor',
    'location': 'Corniche El Nile',
    'image': 'https://images.unsplash.com/photo-1551882547-ff40c63fe5fa',
    'rating': 4.7,
    'reviewCount': 214,
    'price': 172.0,
    'stars': 5,
    'amenities': ['WiFi', 'Spa', 'Airport Shuttle'],
  },
  {
    'id': 'fallback-hotel-3',
    'name': 'Alexandria Harbor Inn',
    'city': 'Alexandria',
    'location': 'Sidi Gaber',
    'image': 'https://images.unsplash.com/photo-1582719508461-905c673771fd',
    'rating': 4.3,
    'reviewCount': 118,
    'price': 109.0,
    'stars': 4,
    'amenities': ['WiFi', 'Sea View'],
  },
];

const List<Map<String, dynamic>> _toursCatalog = [
  {
    'id': 'fallback-tour-1',
    'name': 'Giza Pyramids Sunrise Tour',
    'category': 'Adventure',
    'duration': '6h',
    'image': 'https://images.unsplash.com/photo-1539768942893-daf53e448371',
    'rating': 4.8,
    'reviewCount': 412,
    'price': 55.0,
    'pickupIncluded': true,
  },
  {
    'id': 'fallback-tour-2',
    'name': 'Nile Dinner Cruise',
    'category': 'Cultural',
    'duration': '3h',
    'image': 'https://images.unsplash.com/photo-1467269204594-9661b134dd2b',
    'rating': 4.5,
    'reviewCount': 189,
    'price': 42.0,
    'pickupIncluded': true,
  },
  {
    'id': 'fallback-tour-3',
    'name': 'Valley of the Kings Day Trip',
    'category': 'Adventure',
    'duration': '8h',
    'image': 'https://images.unsplash.com/photo-1524492514790-831f5b4a6f9c',
    'rating': 4.7,
    'reviewCount': 276,
    'price': 78.0,
    'pickupIncluded': false,
  },
];

const List<Map<String, dynamic>> _carsCatalog = [
  {
    'id': 'fallback-car-1',
    'name': 'Toyota Corolla',
    'type': 'Sedan',
    'image': 'https://images.unsplash.com/photo-1549924231-f129b911e442',
    'seats': 5,
    'transmission': 'Automatic',
    'rating': 4.4,
    'reviewCount': 142,
    'price': 39.0,
    'withDriver': false,
    'driverPrice': 0,
  },
  {
    'id': 'fallback-car-2',
    'name': 'Hyundai H1',
    'type': 'Van',
    'image': 'https://images.unsplash.com/photo-1492144534655-ae79c964c9d7',
    'seats': 8,
    'transmission': 'Automatic',
    'rating': 4.6,
    'reviewCount': 95,
    'price': 64.0,
    'withDriver': true,
    'driverPrice': 25,
  },
  {
    'id': 'fallback-car-3',
    'name': 'Jeep Wrangler',
    'type': 'SUV',
    'image': 'https://images.unsplash.com/photo-1502877338535-766e1452684a',
    'seats': 5,
    'transmission': 'Manual',
    'rating': 4.5,
    'reviewCount': 76,
    'price': 58.0,
    'withDriver': false,
    'driverPrice': 0,
  },
];

const List<Map<String, dynamic>> _restaurantsCatalog = [
  {
    'id': 'fallback-restaurant-1',
    'name': 'Koshary El Tahrir',
    'cuisine': 'Egyptian',
    'location': 'Tahrir Square, Cairo',
    'image': 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4',
    'rating': 4.6,
    'reviewCount': 540,
    'priceRange': '\$\$',
    'deliveryTime': 25,
    'delivery': true,
  },
  {
    'id': 'fallback-restaurant-2',
    'name': 'Alex Seafood House',
    'cuisine': 'Seafood',
    'location': 'Corniche, Alexandria',
    'image': 'https://images.unsplash.com/photo-1559339352-11d035aa65de',
    'rating': 4.7,
    'reviewCount': 233,
    'priceRange': '\$\$\$',
    'deliveryTime': 35,
    'delivery': false,
  },
  {
    'id': 'fallback-restaurant-3',
    'name': 'Aswan Spice Grill',
    'cuisine': 'Grill',
    'location': 'Aswan Market',
    'image': 'https://images.unsplash.com/photo-1555992336-03a23c7b20ee',
    'rating': 4.4,
    'reviewCount': 127,
    'priceRange': '\$\$',
    'deliveryTime': 30,
    'delivery': true,
  },
];
