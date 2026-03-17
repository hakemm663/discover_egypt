import '../../../marketplace/domain/models/marketplace_listing.dart';

enum VendorListingStatus { draft, pendingApproval, approved }

class VendorListingDraft {
  const VendorListingDraft({
    required this.id,
    required this.category,
    required this.title,
    required this.city,
    required this.location,
    required this.description,
    required this.price,
    required this.vendorName,
    required this.cancellationPolicy,
    required this.createdAt,
    required this.updatedAt,
    this.currency = 'USD',
    this.images = const <String>[],
    this.tags = const <String>[],
    this.status = VendorListingStatus.draft,
  });

  final String id;
  final MarketplaceCategory category;
  final String title;
  final String city;
  final String location;
  final String description;
  final double price;
  final String vendorName;
  final String cancellationPolicy;
  final String currency;
  final List<String> images;
  final List<String> tags;
  final VendorListingStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  VendorListingDraft copyWith({
    String? id,
    MarketplaceCategory? category,
    String? title,
    String? city,
    String? location,
    String? description,
    double? price,
    String? vendorName,
    String? cancellationPolicy,
    String? currency,
    List<String>? images,
    List<String>? tags,
    VendorListingStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return VendorListingDraft(
      id: id ?? this.id,
      category: category ?? this.category,
      title: title ?? this.title,
      city: city ?? this.city,
      location: location ?? this.location,
      description: description ?? this.description,
      price: price ?? this.price,
      vendorName: vendorName ?? this.vendorName,
      cancellationPolicy: cancellationPolicy ?? this.cancellationPolicy,
      currency: currency ?? this.currency,
      images: images ?? this.images,
      tags: tags ?? this.tags,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category.name,
      'title': title,
      'city': city,
      'location': location,
      'description': description,
      'price': price,
      'vendorName': vendorName,
      'cancellationPolicy': cancellationPolicy,
      'currency': currency,
      'images': images,
      'tags': tags,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory VendorListingDraft.fromJson(Map<String, dynamic> json) {
    return VendorListingDraft(
      id: json['id'] as String? ?? '',
      category: MarketplaceCategory.values.firstWhere(
        (category) => category.name == json['category'],
        orElse: () => MarketplaceCategory.hotel,
      ),
      title: json['title'] as String? ?? '',
      city: json['city'] as String? ?? '',
      location: json['location'] as String? ?? '',
      description: json['description'] as String? ?? '',
      price: (json['price'] as num? ?? 0).toDouble(),
      vendorName: json['vendorName'] as String? ?? 'Discover Egypt Partner',
      cancellationPolicy: json['cancellationPolicy'] as String? ?? '',
      currency: json['currency'] as String? ?? 'USD',
      images: (json['images'] as List<dynamic>? ?? const <dynamic>[])
          .map((value) => value.toString())
          .toList(growable: false),
      tags: (json['tags'] as List<dynamic>? ?? const <dynamic>[])
          .map((value) => value.toString())
          .toList(growable: false),
      status: VendorListingStatus.values.firstWhere(
        (status) => status.name == json['status'],
        orElse: () => VendorListingStatus.draft,
      ),
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  MarketplaceListing toMarketplaceListing() {
    return MarketplaceListing(
      id: id,
      category: category,
      title: title,
      location: location,
      city: city,
      description: description,
      images: images,
      price: price,
      rating: 4.8,
      reviewCount: 0,
      cancellationPolicy: cancellationPolicy,
      vendorName: vendorName,
      currency: currency,
      tags: tags,
      featured: false,
    );
  }
}
