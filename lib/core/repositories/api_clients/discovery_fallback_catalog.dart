import '../../api/generated/models.dart';
import '../../constants/image_urls.dart';
import '../models/pagination_models.dart';

class DiscoveryFallbackCatalog {
  const DiscoveryFallbackCatalog._();

  static PaginatedResult<Map<String, dynamic>> fetchHotels(PaginationQuery query) {
    final filtered = _fallbackHotels.where((item) {
      final city = query.filters['city'];
      return city == null || city == 'All' || item.city == city;
    }).toList(growable: false);

    final sorted = [...filtered];
    final sortBy = query.filters['sortBy'];
    if (sortBy == 'Price: Low to High') {
      sorted.sort((a, b) => a.price.compareTo(b.price));
    } else if (sortBy == 'Price: High to Low') {
      sorted.sort((a, b) => b.price.compareTo(a.price));
    } else if (sortBy == 'Rating') {
      sorted.sort((a, b) => b.rating.compareTo(a.rating));
    } else {
      sorted.sort((a, b) => b.reviewCount.compareTo(a.reviewCount));
    }

    return _page(sorted.map((item) => item.toJson()).toList(growable: false), query);
  }

  static PaginatedResult<Map<String, dynamic>> fetchTours(PaginationQuery query) {
    final filtered = _fallbackTours.where((item) {
      final category = query.filters['category'];
      return category == null || category == 'All' || item.category == category;
    }).toList(growable: false);

    return _page(filtered.map((item) => item.toJson()).toList(growable: false), query);
  }

  static PaginatedResult<Map<String, dynamic>> fetchCars(PaginationQuery query) {
    final filtered = _fallbackCars.where((item) {
      final type = query.filters['type'];
      final withDriverOnly = query.filters['withDriverOnly'] == 'true';
      final typeMatches = type == null || type == 'All' || item.type == type;
      final driverMatches = !withDriverOnly || item.withDriver;
      return typeMatches && driverMatches;
    }).toList(growable: false);

    return _page(filtered.map((item) => item.toJson()).toList(growable: false), query);
  }

  static PaginatedResult<Map<String, dynamic>> fetchRestaurants(PaginationQuery query) {
    final filtered = _fallbackRestaurants.where((item) {
      final cuisine = query.filters['cuisine'];
      return cuisine == null || cuisine == 'All' || item.cuisine == cuisine;
    }).toList(growable: false);

    return _page(filtered.map((item) => item.toJson()).toList(growable: false), query);
  }
}

PaginatedResult<Map<String, dynamic>> _page(
  List<Map<String, dynamic>> items,
  PaginationQuery query,
) {
  final start = query.offset.clamp(0, items.length);
  final end = (start + query.pageSize).clamp(0, items.length);
  final pageItems = items.sublist(start, end);

  return PaginatedResult<Map<String, dynamic>>(
    items: pageItems,
    page: query.page,
    pageSize: query.pageSize,
    totalCount: items.length,
  );
}

const List<Hotel> _fallbackHotels = [
  Hotel(
    id: '1',
    name: 'Pyramids View Hotel',
    city: 'Cairo',
    location: 'Giza, Cairo',
    image: Img.hotelLuxury,
    rating: 4.8,
    reviewCount: 520,
    price: 120.0,
    amenities: ['WiFi', 'Pool', 'Restaurant', 'Spa'],
    stars: 5,
  ),
  Hotel(
    id: '2',
    name: 'Nile Ritz Carlton',
    city: 'Cairo',
    location: 'Downtown Cairo',
    image: Img.hotelPool,
    rating: 4.9,
    reviewCount: 890,
    price: 250.0,
    amenities: ['WiFi', 'Pool', 'Gym', 'Restaurant'],
    stars: 5,
  ),
  Hotel(
    id: '3',
    name: 'Steigenberger Resort',
    city: 'Hurghada',
    location: 'Hurghada',
    image: Img.hotelResort,
    rating: 4.7,
    reviewCount: 430,
    price: 180.0,
    amenities: ['WiFi', 'Beach', 'Pool', 'Spa'],
    stars: 5,
  ),
  Hotel(
    id: '4',
    name: 'Hilton Luxor Resort',
    city: 'Luxor',
    location: 'Luxor City',
    image: Img.hotelRoom,
    rating: 4.6,
    reviewCount: 350,
    price: 140.0,
    amenities: ['WiFi', 'Pool', 'Restaurant'],
    stars: 4,
  ),
  Hotel(
    id: '5',
    name: 'Four Seasons Alexandria',
    city: 'Alexandria',
    location: 'Alexandria Corniche',
    image: Img.hotelLobby,
    rating: 4.9,
    reviewCount: 670,
    price: 300.0,
    amenities: ['WiFi', 'Beach', 'Spa', 'Pool'],
    stars: 5,
  ),
];

const List<Tour> _fallbackTours = [
  Tour(
    id: '1',
    name: 'Pyramids & Sphinx Day Tour',
    category: 'Historical',
    duration: 'Full Day • 8 hours',
    image: Img.pyramidsMain,
    rating: 4.9,
    reviewCount: 1250,
    price: 65.0,
    pickupIncluded: true,
  ),
  Tour(
    id: '2',
    name: 'Nile River Cruise',
    category: 'Cruise',
    duration: '3 Days • Luxor to Aswan',
    image: Img.nileCruise,
    rating: 4.8,
    reviewCount: 890,
    price: 320.0,
    pickupIncluded: true,
  ),
  Tour(
    id: '3',
    name: 'Luxor Temple & Valley of Kings',
    category: 'Historical',
    duration: 'Full Day • 10 hours',
    image: Img.luxorTemple,
    rating: 4.7,
    reviewCount: 720,
    price: 85.0,
    pickupIncluded: true,
  ),
  Tour(
    id: '4',
    name: 'Red Sea Diving Adventure',
    category: 'Adventure',
    duration: 'Half Day • 4 hours',
    image: Img.coralReef,
    rating: 4.9,
    reviewCount: 540,
    price: 95.0,
    pickupIncluded: false,
  ),
  Tour(
    id: '5',
    name: 'Desert Safari & BBQ',
    category: 'Adventure',
    duration: 'Evening • 5 hours',
    image: Img.pyramidsCamels,
    rating: 4.6,
    reviewCount: 380,
    price: 75.0,
    pickupIncluded: true,
  ),
];

const List<Car> _fallbackCars = [
  Car(
    id: '1',
    name: 'Toyota Camry 2023',
    type: 'Sedan',
    image: Img.carSedan,
    seats: 5,
    transmission: 'Automatic',
    rating: 4.8,
    reviewCount: 245,
    price: 45.0,
    withDriver: true,
    driverPrice: 25,
  ),
  Car(
    id: '2',
    name: 'BMW X5',
    type: 'SUV',
    image: Img.carSuv,
    seats: 7,
    transmission: 'Automatic',
    rating: 4.9,
    reviewCount: 189,
    price: 85.0,
    withDriver: true,
    driverPrice: 35,
  ),
  Car(
    id: '3',
    name: 'Mercedes C-Class',
    type: 'Luxury',
    image: Img.carLuxury,
    seats: 5,
    transmission: 'Automatic',
    rating: 4.9,
    reviewCount: 156,
    price: 120.0,
    withDriver: true,
    driverPrice: 45,
  ),
  Car(
    id: '4',
    name: 'Hyundai Staria',
    type: 'Van',
    image: Img.carVan,
    seats: 8,
    transmission: 'Automatic',
    rating: 4.7,
    reviewCount: 320,
    price: 70.0,
    withDriver: false,
    driverPrice: 0,
  ),
];

const List<Restaurant> _fallbackRestaurants = [
  Restaurant(
    id: '1',
    name: 'Koshary Abou Tarek',
    cuisine: 'Egyptian',
    location: 'Downtown Cairo',
    image: Img.koshari,
    rating: 4.7,
    reviewCount: 2100,
    priceRange: r'$4-$10',
    deliveryTime: 30,
    delivery: true,
  ),
  Restaurant(
    id: '2',
    name: 'Sequoia',
    cuisine: 'Mediterranean',
    location: 'Zamalek, Cairo',
    image: Img.restaurant,
    rating: 4.8,
    reviewCount: 1400,
    priceRange: r'$30-$60',
    deliveryTime: 45,
    delivery: true,
  ),
  Restaurant(
    id: '3',
    name: 'Felfela Restaurant',
    cuisine: 'Egyptian',
    location: 'Downtown Cairo',
    image: Img.egyptianFood,
    rating: 4.5,
    reviewCount: 980,
    priceRange: r'$8-$20',
    deliveryTime: 25,
    delivery: false,
  ),
  Restaurant(
    id: '4',
    name: 'Kazoku',
    cuisine: 'Asian',
    location: 'New Cairo',
    image: Img.restaurantInterior,
    rating: 4.9,
    reviewCount: 760,
    priceRange: r'$40-$80',
    deliveryTime: 40,
    delivery: true,
  ),
];
