import '../utils/json_reader.dart';

class HotelListing {
  final String id;
  final String name;
  final String city;
  final String location;
  final String image;
  final double rating;
  final int reviewCount;
  final double price;
  final int stars;
  final List<String> amenities;
  final bool isBookmarked;

  const HotelListing({
    required this.id,
    required this.name,
    required this.city,
    required this.location,
    required this.image,
    required this.rating,
    required this.reviewCount,
    required this.price,
    required this.stars,
    required this.amenities,
    required this.isBookmarked,
  });

  factory HotelListing.fromApi(Map<String, dynamic> json, {required bool isBookmarked}) {
    final r = JsonReader(json);
    return HotelListing(
      id: r.requiredString('id'),
      name: r.requiredString('name'),
      city: r.requiredString('city'),
      location: r.requiredString('location'),
      image: r.requiredString('image'),
      rating: r.requiredDouble('rating'),
      reviewCount: r.requiredInt('reviewCount'),
      price: r.requiredDouble('price'),
      stars: r.intOr('stars', 3),
      amenities: r.stringListOrEmpty('amenities'),
      isBookmarked: isBookmarked,
    );
  }
}

class TourListing {
  final String id;
  final String name;
  final String category;
  final String duration;
  final String image;
  final double rating;
  final int reviewCount;
  final double price;
  final bool pickupIncluded;
  final bool viewedRecently;

  const TourListing({
    required this.id,
    required this.name,
    required this.category,
    required this.duration,
    required this.image,
    required this.rating,
    required this.reviewCount,
    required this.price,
    required this.pickupIncluded,
    required this.viewedRecently,
  });

  factory TourListing.fromApi(Map<String, dynamic> json, {required bool viewedRecently}) {
    final r = JsonReader(json);
    return TourListing(
      id: r.requiredString('id'),
      name: r.requiredString('name'),
      category: r.requiredString('category'),
      duration: r.requiredString('duration'),
      image: r.requiredString('image'),
      rating: r.requiredDouble('rating'),
      reviewCount: r.requiredInt('reviewCount'),
      price: r.requiredDouble('price'),
      pickupIncluded: r.boolOr('pickupIncluded', true),
      viewedRecently: viewedRecently,
    );
  }
}

class CarListing {
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
  final bool isBookmarked;

  const CarListing({
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
    required this.isBookmarked,
  });

  factory CarListing.fromApi(Map<String, dynamic> json, {required bool isBookmarked}) {
    final r = JsonReader(json);
    return CarListing(
      id: r.requiredString('id'),
      name: r.requiredString('name'),
      type: r.requiredString('type'),
      image: r.requiredString('image'),
      seats: r.requiredInt('seats'),
      transmission: r.requiredString('transmission'),
      rating: r.requiredDouble('rating'),
      reviewCount: r.requiredInt('reviewCount'),
      price: r.requiredDouble('price'),
      withDriver: r.boolOr('withDriver', false),
      driverPrice: r.intOr('driverPrice', 0),
      isBookmarked: isBookmarked,
    );
  }
}

class RestaurantListing {
  final String id;
  final String name;
  final String cuisine;
  final String location;
  final String image;
  final double rating;
  final int reviewCount;
  final String priceRange;
  final int deliveryTime;
  final bool delivery;
  final bool isBookmarked;

  const RestaurantListing({
    required this.id,
    required this.name,
    required this.cuisine,
    required this.location,
    required this.image,
    required this.rating,
    required this.reviewCount,
    required this.priceRange,
    required this.deliveryTime,
    required this.delivery,
    required this.isBookmarked,
  });

  factory RestaurantListing.fromApi(Map<String, dynamic> json, {required bool isBookmarked}) {
    final r = JsonReader(json);
    return RestaurantListing(
      id: r.requiredString('id'),
      name: r.requiredString('name'),
      cuisine: r.requiredString('cuisine'),
      location: r.requiredString('location'),
      image: r.requiredString('image'),
      rating: r.requiredDouble('rating'),
      reviewCount: r.requiredInt('reviewCount'),
      priceRange: r.requiredString('priceRange'),
      deliveryTime: r.requiredInt('deliveryTime'),
      delivery: r.boolOr('delivery', false),
      isBookmarked: isBookmarked,
    );
  }
}

class DestinationListing {
  final String name;
  final String image;

  const DestinationListing({required this.name, required this.image});

  factory DestinationListing.fromApi(Map<String, dynamic> json) {
    final r = JsonReader(json);
    return DestinationListing(name: r.requiredString('name'), image: r.requiredString('image'));
  }
}
