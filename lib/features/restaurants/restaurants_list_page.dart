import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/constants/image_urls.dart';
import '../../core/widgets/app_bar_widget.dart';
import '../../core/widgets/rounded_card.dart';
import '../../core/widgets/rating_widget.dart';

class RestaurantsListPage extends ConsumerStatefulWidget {
  const RestaurantsListPage({super.key});

  @override
  ConsumerState<RestaurantsListPage> createState() => _RestaurantsListPageState();
}

class _RestaurantsListPageState extends ConsumerState<RestaurantsListPage> {
  String _selectedCuisine = 'All';

  final List<Map<String, dynamic>> _restaurants = [
    {
      'id': '1',
      'name': 'Naguib Mahfouz Cafe',
      'cuisine': 'Egyptian',
      'location': 'Khan El Khalili, Cairo',
      'image': Img.restaurant,
      'rating': 4.7,
      'reviewCount': 890,
      'priceRange': '\$\$',
      'delivery': true,
      'deliveryTime': 30,
    },
    {
      'id': '2',
      'name': 'Abou El Sid',
      'cuisine': 'Egyptian',
      'location': 'Zamalek, Cairo',
      'image': Img.egyptianFood,
      'rating': 4.8,
      'reviewCount': 1240,
      'priceRange': '\$\$',
      'delivery': true,
      'deliveryTime': 35,
    },
    {
      'id': '3',
      'name': 'Sequoia',
      'cuisine': 'Mediterranean',
      'location': 'Zamalek, Cairo',
      'image': Img.restaurantInterior,
      'rating': 4.6,
      'reviewCount': 670,
      'priceRange': '\$\$\$',
      'delivery': false,
      'deliveryTime': 0,
    },
    {
      'id': '4',
      'name': 'Koshari Abou Tarek',
      'cuisine': 'Egyptian',
      'location': 'Downtown Cairo',
      'image': Img.koshari,
      'rating': 4.9,
      'reviewCount': 2100,
      'priceRange': '\$',
      'delivery': true,
      'deliveryTime': 20,
    },
  ];

  List<Map<String, dynamic>> get _filteredRestaurants {
    if (_selectedCuisine == 'All') return _restaurants;
    return _restaurants.where((r) => r['cuisine'] == _selectedCuisine).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Restaurants & Cafes',
        showBackButton: true,
      ),
      body: Column(
        children: [
          // Cuisine Filter
          Container(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['All', 'Egyptian', 'Mediterranean', 'Italian', 'Asian']
                    .map((cuisine) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(cuisine),
                            selected: _selectedCuisine == cuisine,
                            onSelected: (selected) {
                              setState(() => _selectedCuisine = cuisine);
                            },
                            selectedColor: const Color(0xFFC89B3C).withValues(alpha: 0.2),
                            checkmarkColor: const Color(0xFFC89B3C),
                          ),
                        ))
                    .toList(),
              ),
            ),
          ),

          // Restaurants List
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _filteredRestaurants.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final restaurant = _filteredRestaurants[index];
                return _RestaurantListItem(restaurant: restaurant)
                    .animate(delay: Duration(milliseconds: 100 * index))
                    .fadeIn(duration: 400.ms)
                    .slideX(begin: 0.2, end: 0);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _RestaurantListItem extends StatelessWidget {
  final Map<String, dynamic> restaurant;

  const _RestaurantListItem({required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/restaurant/${restaurant['id']}'),
      child: RoundedCard(
        padding: EdgeInsets.zero,
        child: Row(
          children: [
            // Image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
              child: SizedBox(
                width: 120,
                height: 140,
                child: CachedNetworkImage(
                  imageUrl: restaurant['image'],
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      restaurant['name'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.restaurant_outlined, size: 14, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          restaurant['cuisine'],
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          restaurant['priceRange'],
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFC89B3C),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined, size: 14, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            restaurant['location'],
                            style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    RatingWidget(
                      rating: restaurant['rating'],
                      reviewCount: restaurant['reviewCount'],
                      size: 14,
                    ),
                    const SizedBox(height: 8),
                    if (restaurant['delivery'])
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.delivery_dining_rounded, size: 14, color: Colors.green[700]),
                            const SizedBox(width: 4),
                            Text(
                              '${restaurant['deliveryTime']} min',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.green[700],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}