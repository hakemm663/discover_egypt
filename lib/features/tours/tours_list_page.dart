import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/constants/image_urls.dart';
import '../../core/widgets/app_bar_widget.dart';
import '../../core/widgets/rounded_card.dart';
import '../../core/widgets/rating_widget.dart';
import '../../core/widgets/price_tag.dart';

class ToursListPage extends ConsumerStatefulWidget {
  const ToursListPage({super.key});

  @override
  ConsumerState<ToursListPage> createState() => _ToursListPageState();
}

class _ToursListPageState extends ConsumerState<ToursListPage> {
  String _selectedCategory = 'All';

  final List<Map<String, dynamic>> _tours = [
    {
      'id': '1',
      'name': 'Pyramids & Sphinx Day Tour',
      'category': 'Historical',
      'duration': 'Full Day • 8 hours',
      'image': Img.pyramidsMain,
      'rating': 4.9,
      'reviewCount': 1250,
      'price': 65.0,
      'pickupIncluded': true,
    },
    {
      'id': '2',
      'name': 'Nile River Cruise',
      'category': 'Cruise',
      'duration': '3 Days • Luxor to Aswan',
      'image': Img.nileCruise,
      'rating': 4.8,
      'reviewCount': 890,
      'price': 320.0,
      'pickupIncluded': true,
    },
    {
      'id': '3',
      'name': 'Luxor Temple & Valley of Kings',
      'category': 'Historical',
      'duration': 'Full Day • 10 hours',
      'image': Img.luxorTemple,
      'rating': 4.7,
      'reviewCount': 720,
      'price': 85.0,
      'pickupIncluded': true,
    },
    {
      'id': '4',
      'name': 'Red Sea Diving Adventure',
      'category': 'Adventure',
      'duration': 'Half Day • 4 hours',
      'image': Img.coralReef,
      'rating': 4.9,
      'reviewCount': 540,
      'price': 95.0,
      'pickupIncluded': false,
    },
    {
      'id': '5',
      'name': 'Desert Safari & BBQ',
      'category': 'Adventure',
      'duration': 'Evening • 5 hours',
      'image': Img.pyramidsCamels,
      'rating': 4.6,
      'reviewCount': 380,
      'price': 75.0,
      'pickupIncluded': true,
    },
  ];

  List<Map<String, dynamic>> get _filteredTours {
    if (_selectedCategory == 'All') return _tours;
    return _tours.where((t) => t['category'] == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Tours & Experiences',
        showBackButton: true,
      ),
      body: Column(
        children: [
          // Category Filter
          Container(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['All', 'Historical', 'Adventure', 'Cruise', 'Cultural']
                    .map((cat) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(cat),
                            selected: _selectedCategory == cat,
                            onSelected: (selected) {
                              setState(() => _selectedCategory = cat);
                            },
                            selectedColor: const Color(0xFFC89B3C).withValues(alpha: 0.2),
                            checkmarkColor: const Color(0xFFC89B3C),
                          ),
                        ))
                    .toList(),
              ),
            ),
          ),

          // Tours List
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _filteredTours.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final tour = _filteredTours[index];
                return _TourListItem(tour: tour)
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

class _TourListItem extends StatelessWidget {
  final Map<String, dynamic> tour;

  const _TourListItem({required this.tour});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/tour/${tour['id']}'),
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
                width: 130,
                height: 160,
                child: CachedNetworkImage(
                  imageUrl: tour['image'],
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
                    // Category Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFC89B3C).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        tour['category'],
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFC89B3C),
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      tour['name'],
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 6),

                    Row(
                      children: [
                        Icon(Icons.access_time_rounded, size: 14, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            tour['duration'],
                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),

                    if (tour['pickupIncluded'])
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Row(
                          children: [
                            Icon(Icons.check_circle_outline, size: 14, color: Colors.green[600]),
                            const SizedBox(width: 4),
                            Text(
                              'Pickup included',
                              style: TextStyle(fontSize: 11, color: Colors.green[600]),
                            ),
                          ],
                        ),
                      ),

                    const SizedBox(height: 8),

                    RatingWidget(
                      rating: tour['rating'],
                      reviewCount: tour['reviewCount'],
                      size: 14,
                    ),

                    const SizedBox(height: 8),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        PriceTag(price: tour['price']),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFC89B3C).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'View',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFFC89B3C),
                            ),
                          ),
                        ),
                      ],
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
