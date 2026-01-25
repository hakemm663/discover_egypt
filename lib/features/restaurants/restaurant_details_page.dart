import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/image_urls.dart';
import '../../core/widgets/app_bar_widget.dart';
import '../../core/widgets/rounded_card.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/rating_widget.dart';
import '../../core/widgets/image_carousel.dart';

class RestaurantDetailsPage extends ConsumerWidget {
  final String id;

  const RestaurantDetailsPage({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final restaurant = {
      'id': id,
      'name': 'Naguib Mahfouz Cafe',
      'cuisine': 'Egyptian',
      'location': 'Khan El Khalili, Cairo',
      'images': [Img.restaurant, Img.egyptianFood, Img.restaurantInterior],
      'rating': 4.7,
      'reviewCount': 890,
      'priceRange': '\$\$',
      'description':
          'Experience authentic Egyptian cuisine in the heart of historic Khan El Khalili. Our restaurant offers traditional dishes, warm hospitality, and a unique atmosphere.',
      'openingHours': '10:00 AM - 11:00 PM',
      'delivery': true,
      'deliveryTime': 30,
      'deliveryFee': 5.0,
      'menu': [
        {'name': 'Koshari', 'price': 8.0, 'description': 'Traditional Egyptian dish'},
        {'name': 'Ful Medames', 'price': 6.0, 'description': 'Fava beans with spices'},
        {'name': 'Shawarma', 'price': 12.0, 'description': 'Grilled meat wrap'},
        {'name': 'Molokhia', 'price': 10.0, 'description': 'Green soup with rice'},
        {'name': 'Mahshi', 'price': 15.0, 'description': 'Stuffed vegetables'},
      ],
    };

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Restaurant Details',
        showBackButton: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ImageCarousel(
                  images: restaurant['images'] as List<String>,
                  height: 280,
                  borderRadius: 0,
                ),

                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        restaurant['name'] as String,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                      ),

                      const SizedBox(height: 8),

                      Row(
                        children: [
                          Icon(Icons.restaurant_outlined, size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 6),
                          Text(
                            restaurant['cuisine'] as String,
                            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            restaurant['priceRange'] as String,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFFC89B3C),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      Row(
                        children: [
                          Icon(Icons.location_on_outlined, size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 6),
                          Text(
                            restaurant['location'] as String,
                            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      RatingWidget(
                        rating: restaurant['rating'] as double,
                        reviewCount: restaurant['reviewCount'] as int?,
                        size: 18,
                      ),

                      const SizedBox(height: 20),

                      // Info Cards
                      Row(
                        children: [
                          Expanded(
                            child: _InfoCard(
                              icon: Icons.access_time_rounded,
                              title: 'Hours',
                              subtitle: restaurant['openingHours'] as String,
                            ),
                          ),
                          const SizedBox(width: 12),
                          if (restaurant['delivery'] as bool)
                            Expanded(
                              child: _InfoCard(
                                icon: Icons.delivery_dining_rounded,
                                title: 'Delivery',
                                subtitle: '${restaurant['deliveryTime']} min',
                              ),
                            ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      Text(
                        'About',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        restaurant['description'] as String,
                        style: TextStyle(fontSize: 14, color: Colors.grey[700], height: 1.6),
                      ),

                      const SizedBox(height: 20),

                      Text(
                        'Popular Dishes',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                      const SizedBox(height: 12),

                      ...(restaurant['menu'] as List).map(
                        (item) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: RoundedCard(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item['name'] as String,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        item['description'] as String,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  '\$${item['price']}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFFC89B3C),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Bottom Bar
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
                    Expanded(
                      child: PrimaryButton(
                        label: 'Reserve Table',
                        icon: Icons.table_restaurant_rounded,
                        onPressed: () => context.push('/booking-summary'),
                      ),
                    ),
                    if (restaurant['delivery'] as bool) ...[
                      const SizedBox(width: 12),
                      Expanded(
                        child: PrimaryButton(
                          label: 'Order Delivery',
                          icon: Icons.delivery_dining_rounded,
                          isOutlined: true,
                          onPressed: () => context.push('/booking-summary'),
                        ),
                      ),
                    ],
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

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFC89B3C).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFFC89B3C), size: 24),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[700],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}