enum MarketplaceCategory {
  hotel,
  apartment,
  tour,
  car,
  guide,
  attraction,
  restaurant,
}

extension MarketplaceCategoryX on MarketplaceCategory {
  String get label {
    switch (this) {
      case MarketplaceCategory.hotel:
        return 'Hotels';
      case MarketplaceCategory.apartment:
        return 'Apartments';
      case MarketplaceCategory.tour:
        return 'Tours';
      case MarketplaceCategory.car:
        return 'Cars';
      case MarketplaceCategory.guide:
        return 'Guides';
      case MarketplaceCategory.attraction:
        return 'Attractions';
      case MarketplaceCategory.restaurant:
        return 'Restaurants';
    }
  }

  bool get isBookable => this != MarketplaceCategory.restaurant;
}

class MarketplaceListing {
  const MarketplaceListing({
    required this.id,
    required this.category,
    required this.title,
    required this.location,
    required this.city,
    required this.description,
    required this.images,
    required this.price,
    required this.rating,
    required this.reviewCount,
    required this.cancellationPolicy,
    required this.vendorName,
    this.currency = 'USD',
    this.tags = const <String>[],
    this.featured = false,
  });

  final String id;
  final MarketplaceCategory category;
  final String title;
  final String location;
  final String city;
  final String description;
  final List<String> images;
  final double price;
  final double rating;
  final int reviewCount;
  final String cancellationPolicy;
  final String vendorName;
  final String currency;
  final List<String> tags;
  final bool featured;

  String get primaryImage => images.isEmpty ? '' : images.first;
}
