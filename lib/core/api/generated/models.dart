// GENERATED CODE - DO NOT MODIFY BY HAND.
// Source: docs/openapi/discovery_api.openapi.json

class Hotel {
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

        const Hotel({
          required this.id,
  required this.name,
  required this.city,
  required this.location,
  required this.image,
  required this.rating,
  required this.reviewCount,
  required this.price,
  required this.amenities,
  required this.stars,
        });

        factory Hotel.fromJson(Map<String, dynamic> json) {
          return Hotel(
            id: (json['id'] as String),
    name: (json['name'] as String),
    city: (json['city'] as String),
    location: (json['location'] as String),
    image: (json['image'] as String),
    rating: (json['rating'] as num).toDouble(),
    reviewCount: (json['reviewCount'] as int),
    price: (json['price'] as num).toDouble(),
    amenities: (json['amenities'] as List<dynamic>? ?? const []).map((e) => e as String).toList(growable: false),
    stars: (json['stars'] as int),
          );
        }

        Map<String, dynamic> toJson() {
          return {
            'id': id,
    'name': name,
    'city': city,
    'location': location,
    'image': image,
    'rating': rating,
    'reviewCount': reviewCount,
    'price': price,
    'amenities': amenities,
    'stars': stars,
          };
        }
      }

class Tour {
        final String id;
final String name;
final String category;
final String duration;
final String image;
final double rating;
final int reviewCount;
final double price;
final bool pickupIncluded;

        const Tour({
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

        factory Tour.fromJson(Map<String, dynamic> json) {
          return Tour(
            id: (json['id'] as String),
    name: (json['name'] as String),
    category: (json['category'] as String),
    duration: (json['duration'] as String),
    image: (json['image'] as String),
    rating: (json['rating'] as num).toDouble(),
    reviewCount: (json['reviewCount'] as int),
    price: (json['price'] as num).toDouble(),
    pickupIncluded: (json['pickupIncluded'] as bool),
          );
        }

        Map<String, dynamic> toJson() {
          return {
            'id': id,
    'name': name,
    'category': category,
    'duration': duration,
    'image': image,
    'rating': rating,
    'reviewCount': reviewCount,
    'price': price,
    'pickupIncluded': pickupIncluded,
          };
        }
      }

class Car {
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

        const Car({
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

        factory Car.fromJson(Map<String, dynamic> json) {
          return Car(
            id: (json['id'] as String),
    name: (json['name'] as String),
    type: (json['type'] as String),
    image: (json['image'] as String),
    seats: (json['seats'] as int),
    transmission: (json['transmission'] as String),
    rating: (json['rating'] as num).toDouble(),
    reviewCount: (json['reviewCount'] as int),
    price: (json['price'] as num).toDouble(),
    withDriver: (json['withDriver'] as bool),
    driverPrice: (json['driverPrice'] as int),
          );
        }

        Map<String, dynamic> toJson() {
          return {
            'id': id,
    'name': name,
    'type': type,
    'image': image,
    'seats': seats,
    'transmission': transmission,
    'rating': rating,
    'reviewCount': reviewCount,
    'price': price,
    'withDriver': withDriver,
    'driverPrice': driverPrice,
          };
        }
      }

class Restaurant {
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

        const Restaurant({
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
        });

        factory Restaurant.fromJson(Map<String, dynamic> json) {
          return Restaurant(
            id: (json['id'] as String),
    name: (json['name'] as String),
    cuisine: (json['cuisine'] as String),
    location: (json['location'] as String),
    image: (json['image'] as String),
    rating: (json['rating'] as num).toDouble(),
    reviewCount: (json['reviewCount'] as int),
    priceRange: (json['priceRange'] as String),
    deliveryTime: (json['deliveryTime'] as int),
    delivery: (json['delivery'] as bool),
          );
        }

        Map<String, dynamic> toJson() {
          return {
            'id': id,
    'name': name,
    'cuisine': cuisine,
    'location': location,
    'image': image,
    'rating': rating,
    'reviewCount': reviewCount,
    'priceRange': priceRange,
    'deliveryTime': deliveryTime,
    'delivery': delivery,
          };
        }
      }

class HotelListResponse {
  final List<Hotel> items;

  const HotelListResponse({required this.items});

  factory HotelListResponse.fromJson(Map<String, dynamic> json) {
    return HotelListResponse(
      items: (json['items'] as List<dynamic>? ?? const [])
          .map((e) => Hotel.fromJson(e as Map<String, dynamic>))
          .toList(growable: false),
    );
  }
}

class TourListResponse {
  final List<Tour> items;

  const TourListResponse({required this.items});

  factory TourListResponse.fromJson(Map<String, dynamic> json) {
    return TourListResponse(
      items: (json['items'] as List<dynamic>? ?? const [])
          .map((e) => Tour.fromJson(e as Map<String, dynamic>))
          .toList(growable: false),
    );
  }
}

class CarListResponse {
  final List<Car> items;

  const CarListResponse({required this.items});

  factory CarListResponse.fromJson(Map<String, dynamic> json) {
    return CarListResponse(
      items: (json['items'] as List<dynamic>? ?? const [])
          .map((e) => Car.fromJson(e as Map<String, dynamic>))
          .toList(growable: false),
    );
  }
}

class RestaurantListResponse {
  final List<Restaurant> items;

  const RestaurantListResponse({required this.items});

  factory RestaurantListResponse.fromJson(Map<String, dynamic> json) {
    return RestaurantListResponse(
      items: (json['items'] as List<dynamic>? ?? const [])
          .map((e) => Restaurant.fromJson(e as Map<String, dynamic>))
          .toList(growable: false),
    );
  }
}
