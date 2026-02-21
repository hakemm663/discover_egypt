import '../../constants/api_endpoints.dart';
import '../../constants/image_urls.dart';
import '../models/pagination_models.dart';

class HotelsApiClient {
  String get endpoint => '${ApiEndpoints.baseUrl}${ApiEndpoints.hotels}';

  Future<PaginatedResult<Map<String, dynamic>>> fetchHotels(PaginationQuery query) async {
    await Future<void>.delayed(const Duration(milliseconds: 120));
    final filtered = _hotels.where((item) {
      final city = query.filters['city'];
      return city == null || city == 'All' || item['city'] == city;
    }).toList();
    final sorted = _sort(filtered, query.filters['sortBy']);
    return _page(sorted, query);
  }

  List<Map<String, dynamic>> _sort(List<Map<String, dynamic>> source, String? sortBy) {
    final items = [...source];
    if (sortBy == 'Price: Low to High') {
      items.sort((a, b) => (a['price'] as num).compareTo(b['price'] as num));
      return items;
    }
    if (sortBy == 'Price: High to Low') {
      items.sort((a, b) => (b['price'] as num).compareTo(a['price'] as num));
      return items;
    }
    if (sortBy == 'Rating') {
      items.sort((a, b) => (b['rating'] as num).compareTo(a['rating'] as num));
      return items;
    }
    items.sort((a, b) => (b['reviewCount'] as int).compareTo(a['reviewCount'] as int));
    return items;
  }
}

class ToursApiClient {
  String get endpoint => '${ApiEndpoints.baseUrl}${ApiEndpoints.tours}';

  Future<PaginatedResult<Map<String, dynamic>>> fetchTours(PaginationQuery query) async {
    await Future<void>.delayed(const Duration(milliseconds: 120));
    final filtered = _tours.where((item) {
      final category = query.filters['category'];
      return category == null || category == 'All' || item['category'] == category;
    }).toList();
    return _page(filtered, query);
  }
}

class CarsApiClient {
  String get endpoint => '${ApiEndpoints.baseUrl}${ApiEndpoints.cars}';

  Future<PaginatedResult<Map<String, dynamic>>> fetchCars(PaginationQuery query) async {
    await Future<void>.delayed(const Duration(milliseconds: 120));
    final filtered = _cars.where((item) {
      final type = query.filters['type'];
      final withDriverOnly = query.filters['withDriverOnly'] == 'true';
      final typeMatches = type == null || type == 'All' || item['type'] == type;
      final driverMatches = !withDriverOnly || item['withDriver'] == true;
      return typeMatches && driverMatches;
    }).toList();
    return _page(filtered, query);
  }
}

class RestaurantsApiClient {
  String get endpoint => '${ApiEndpoints.baseUrl}${ApiEndpoints.restaurants}';

  Future<PaginatedResult<Map<String, dynamic>>> fetchRestaurants(PaginationQuery query) async {
    await Future<void>.delayed(const Duration(milliseconds: 120));
    final filtered = _restaurants.where((item) {
      final cuisine = query.filters['cuisine'];
      return cuisine == null || cuisine == 'All' || item['cuisine'] == cuisine;
    }).toList();
    return _page(filtered, query);
  }
}

PaginatedResult<Map<String, dynamic>> _page(List<Map<String, dynamic>> items, PaginationQuery query) {
  final start = query.offset.clamp(0, items.length);
  final end = (start + query.pageSize).clamp(0, items.length);
  return PaginatedResult(
    items: items.sublist(start, end),
    page: query.page,
    pageSize: query.pageSize,
    totalCount: items.length,
  );
}

const _hotels = [
  {'id': '1', 'name': 'Pyramids View Hotel', 'city': 'Cairo', 'location': 'Giza, Cairo', 'image': Img.hotelLuxury, 'rating': 4.8, 'reviewCount': 520, 'price': 120.0, 'amenities': ['WiFi', 'Pool', 'Restaurant', 'Spa'], 'stars': 5},
  {'id': '2', 'name': 'Nile Ritz Carlton', 'city': 'Cairo', 'location': 'Downtown Cairo', 'image': Img.hotelPool, 'rating': 4.9, 'reviewCount': 890, 'price': 250.0, 'amenities': ['WiFi', 'Pool', 'Gym', 'Restaurant'], 'stars': 5},
  {'id': '3', 'name': 'Steigenberger Resort', 'city': 'Hurghada', 'location': 'Hurghada', 'image': Img.hotelResort, 'rating': 4.7, 'reviewCount': 430, 'price': 180.0, 'amenities': ['WiFi', 'Beach', 'Pool', 'Spa'], 'stars': 5},
  {'id': '4', 'name': 'Hilton Luxor Resort', 'city': 'Luxor', 'location': 'Luxor City', 'image': Img.hotelRoom, 'rating': 4.6, 'reviewCount': 350, 'price': 140.0, 'amenities': ['WiFi', 'Pool', 'Restaurant'], 'stars': 4},
  {'id': '5', 'name': 'Four Seasons Alexandria', 'city': 'Alexandria', 'location': 'Alexandria Corniche', 'image': Img.hotelLobby, 'rating': 4.9, 'reviewCount': 670, 'price': 300.0, 'amenities': ['WiFi', 'Beach', 'Spa', 'Pool'], 'stars': 5},
];

const _tours = [
  {'id': '1', 'name': 'Pyramids & Sphinx Day Tour', 'category': 'Historical', 'duration': 'Full Day • 8 hours', 'image': Img.pyramidsMain, 'rating': 4.9, 'reviewCount': 1250, 'price': 65.0, 'pickupIncluded': true},
  {'id': '2', 'name': 'Nile River Cruise', 'category': 'Cruise', 'duration': '3 Days • Luxor to Aswan', 'image': Img.nileCruise, 'rating': 4.8, 'reviewCount': 890, 'price': 320.0, 'pickupIncluded': true},
  {'id': '3', 'name': 'Luxor Temple & Valley of Kings', 'category': 'Historical', 'duration': 'Full Day • 10 hours', 'image': Img.luxorTemple, 'rating': 4.7, 'reviewCount': 720, 'price': 85.0, 'pickupIncluded': true},
  {'id': '4', 'name': 'Red Sea Diving Adventure', 'category': 'Adventure', 'duration': 'Half Day • 4 hours', 'image': Img.coralReef, 'rating': 4.9, 'reviewCount': 540, 'price': 95.0, 'pickupIncluded': false},
  {'id': '5', 'name': 'Desert Safari & BBQ', 'category': 'Adventure', 'duration': 'Evening • 5 hours', 'image': Img.pyramidsCamels, 'rating': 4.6, 'reviewCount': 380, 'price': 75.0, 'pickupIncluded': true},
];

const _cars = [
  {'id': '1', 'name': 'Toyota Camry 2023', 'type': 'Sedan', 'image': Img.carSedan, 'seats': 5, 'transmission': 'Automatic', 'rating': 4.8, 'reviewCount': 245, 'price': 45.0, 'withDriver': true, 'driverPrice': 25},
  {'id': '2', 'name': 'BMW X5', 'type': 'SUV', 'image': Img.carSuv, 'seats': 7, 'transmission': 'Automatic', 'rating': 4.9, 'reviewCount': 189, 'price': 85.0, 'withDriver': true, 'driverPrice': 35},
  {'id': '3', 'name': 'Mercedes C-Class', 'type': 'Luxury', 'image': Img.carLuxury, 'seats': 5, 'transmission': 'Automatic', 'rating': 4.9, 'reviewCount': 156, 'price': 120.0, 'withDriver': true, 'driverPrice': 45},
  {'id': '4', 'name': 'Hyundai Staria', 'type': 'Van', 'image': Img.carVan, 'seats': 8, 'transmission': 'Automatic', 'rating': 4.7, 'reviewCount': 320, 'price': 70.0, 'withDriver': false, 'driverPrice': 0},
];

const _restaurants = [
  {'id': '1', 'name': 'Koshary Abou Tarek', 'cuisine': 'Egyptian', 'location': 'Downtown Cairo', 'image': Img.koshari, 'rating': 4.7, 'reviewCount': 2100, 'priceRange': r'$4-$10', 'deliveryTime': 30, 'delivery': true},
  {'id': '2', 'name': 'Sequoia', 'cuisine': 'Mediterranean', 'location': 'Zamalek, Cairo', 'image': Img.restaurant, 'rating': 4.8, 'reviewCount': 1400, 'priceRange': r'$30-$60', 'deliveryTime': 45, 'delivery': true},
  {'id': '3', 'name': 'Felfela Restaurant', 'cuisine': 'Egyptian', 'location': 'Downtown Cairo', 'image': Img.egyptianFood, 'rating': 4.5, 'reviewCount': 980, 'priceRange': r'$8-$20', 'deliveryTime': 25, 'delivery': false},
  {'id': '4', 'name': 'Kazoku', 'cuisine': 'Asian', 'location': 'New Cairo', 'image': Img.restaurantInterior, 'rating': 4.9, 'reviewCount': 760, 'priceRange': r'$40-$80', 'deliveryTime': 40, 'delivery': true},
];
