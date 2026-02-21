import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/image_urls.dart';
import '../../core/widgets/custom_app_bar.dart';
import '../../core/widgets/rating_widget.dart';
import '../../core/widgets/image_carousel.dart';

class TourDetailsPage extends ConsumerWidget {
  final String id;

  const TourDetailsPage({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tour = {
      'id': id,
      'name': 'Pyramids & Sphinx Day Tour',
      'images': [Img.pyramidsMain, Img.pyramidsSphinx, Img.pyramidsCamels],
      'rating': 4.9,
      'reviewCount': 1250,
      'price': 65.0,
      'duration': 'Full Day • 8 hours',
      'description':
          'Explore the iconic Pyramids of Giza and the Great Sphinx on this comprehensive day tour. Learn about ancient Egyptian civilization from our expert guides.',
      'includes': [
        'Hotel pickup and drop-off',
        'Professional Egyptologist guide',
        'Entrance fees',
        'Lunch at local restaurant',
        'Bottled water',
      ],
      'excludes': [
        'Gratuities',
        'Personal expenses',
        'Camel ride (optional)',
      ],
      'highlights': [
        'Great Pyramid of Khufu',
        'Pyramid of Khafre',
        'Pyramid of Menkaure',
        'The Great Sphinx',
        'Valley Temple',
      ],
    };

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Tour Details',
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
                ImageCarousel(
                  images: tour['images'] as List<String>,
                  height: 280,
                  borderRadius: 0,
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tour['name'] as String,
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w800,
                                ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.access_time_rounded,
                              size: 18, color: Colors.grey[600]),
                          const SizedBox(width: 6),
                          Text(
                            tour['duration'] as String,
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      RatingWidget(
                        rating: tour['rating'] as double,
                        reviewCount: tour['reviewCount'] as int?,
                        size: 18,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Description',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w800,
                                ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        tour['description'] as String,
                        style: TextStyle(
                            fontSize: 14, color: Colors.grey[700], height: 1.6),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Highlights',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w800,
                                ),
                      ),
                      const SizedBox(height: 12),
                      ...(tour['highlights'] as List<String>).map(
                        (h) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.check_circle,
                                color: Color(0xFFC89B3C),
                                size: 20,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  h,
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.grey[700]),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'What\'s Included',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w800,
                                ),
                      ),
                      const SizedBox(height: 12),
                      ...(tour['includes'] as List<String>).map(
                        (i) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.add_circle_outline,
                                  color: Colors.green[600], size: 18),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  i,
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.grey[700]),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'What\'s Not Included',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w800,
                                ),
                      ),
                      const SizedBox(height: 12),
                      ...(tour['excludes'] as List<String>).map(
                        (e) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.remove_circle_outline,
                                  color: Colors.red[400], size: 18),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  e,
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.grey[700]),
                                ),
                              ),
                            ],
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

          // Book Now Button
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              color: Colors.white,
              child: ElevatedButton(
                onPressed: () {
                  context.push('/booking-summary');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFC89B3C),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text(
                  'Book Now',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
