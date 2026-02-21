import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/image_urls.dart';
import '../../core/widgets/custom_app_bar.dart';
import '../../core/widgets/rounded_card.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/rating_widget.dart';
import '../../core/widgets/price_tag.dart';
import '../../core/widgets/image_carousel.dart';

class HotelDetailsPage extends ConsumerWidget {
  final String id;

  const HotelDetailsPage({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Mock data - replace with real API call
    final hotel = {
      'id': id,
      'name': 'Pyramids View Hotel',
      'location': 'Giza, Cairo',
      'images': [Img.hotelLuxury, Img.hotelPool, Img.hotelRoom, Img.hotelLobby],
      'rating': 4.8,
      'reviewCount': 520,
      'price': 120.0,
      'description':
          'Experience luxury with stunning views of the Pyramids. Our hotel offers world-class amenities, exceptional service, and a prime location near all major attractions.',
      'amenities': [
        {'icon': Icons.wifi, 'name': 'Free WiFi'},
        {'icon': Icons.pool, 'name': 'Swimming Pool'},
        {'icon': Icons.restaurant, 'name': 'Restaurant'},
        {'icon': Icons.spa, 'name': 'Spa'},
        {'icon': Icons.fitness_center, 'name': 'Gym'},
        {'icon': Icons.local_parking, 'name': 'Parking'},
        {'icon': Icons.room_service, 'name': 'Room Service'},
        {'icon': Icons.ac_unit, 'name': 'Air Conditioning'},
      ],
      'latitude': 29.9773,
      'longitude': 31.1325,
    };

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Hotel Details',
        showBackButton: true,
        additionalActions: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Share is coming soon.')),
              );
            },
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.share_rounded, size: 20),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Carousel
                ImageCarousel(
                  images: hotel['images'] as List<String>,
                  height: 280,
                  borderRadius: 0,
                ),

                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title & Rating
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              hotel['name'] as String,
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.w800,
                                  ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.red.shade100),
                            ),
                            child: Icon(
                              Icons.favorite_border_rounded,
                              color: Colors.red[400],
                              size: 24,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      Row(
                        children: [
                          Icon(Icons.location_on_outlined, size: 18, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(
                            hotel['location'] as String,
                            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      RatingWidget(
                        rating: hotel['rating'] as double,
                        reviewCount: hotel['reviewCount'] as int?,
                        size: 18,
                      ),

                      const SizedBox(height: 20),

                      // Description
                      Text(
                        'About',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        hotel['description'] as String,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                          height: 1.6,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Amenities
                      Text(
                        'Amenities',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                      const SizedBox(height: 12),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 1.0,
                        ),
                        itemCount: (hotel['amenities'] as List).length,
                        itemBuilder: (context, index) {
                          final amenity = (hotel['amenities'] as List)[index];
                          return Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFC89B3C).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  amenity['icon'],
                                  color: const Color(0xFFC89B3C),
                                  size: 24,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  amenity['name'],
                                  style: const TextStyle(fontSize: 10),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 20),

                      // Location Map
                      Text(
                        'Location',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                      const SizedBox(height: 12),
                      RoundedCard(
                        padding: EdgeInsets.zero,
                        child: Container(
                          height: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.grey[200],
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.map_outlined, size: 48, color: Color(0xFFC89B3C)),
                                const SizedBox(height: 8),
                                Text(
                                  'Map View',
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Lat: ${hotel['latitude']}, Lng: ${hotel['longitude']}',
                                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 100), // Space for bottom bar
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Bottom Booking Bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Price per night',
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 4),
                        PriceTag(price: hotel['price'] as double, unit: 'night', large: true),
                      ],
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: PrimaryButton(
                        label: 'Book Now',
                        onPressed: () => context.push('/booking-summary'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
