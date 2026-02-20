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

class CarDetailsPage extends ConsumerStatefulWidget {
  final String id;

  const CarDetailsPage({super.key, required this.id});

  @override
  ConsumerState<CarDetailsPage> createState() => _CarDetailsPageState();
}

class _CarDetailsPageState extends ConsumerState<CarDetailsPage> {
  bool _withDriver = false;

  @override
  Widget build(BuildContext context) {
    final car = {
      'id': widget.id,
      'name': 'Mercedes S-Class',
      'brand': 'Mercedes',
      'model': 'S500',
      'year': 2023,
      'type': 'Luxury',
      'images': [Img.carLuxury, Img.carSedan],
      'rating': 4.9,
      'reviewCount': 230,
      'price': 150.0,
      'driverPrice': 50.0,
      'description':
          'Experience ultimate luxury with our Mercedes S-Class. Perfect for business trips or special occasions. Features premium leather seats, advanced sound system, and smooth ride.',
      'seats': 4,
      'transmission': 'Automatic',
      'fuelType': 'Petrol',
      'features': [
        'Leather Seats',
        'Sunroof',
        'GPS Navigation',
        'Bluetooth',
        'USB Charging',
        'Climate Control',
        'Premium Audio',
        'Rear Camera',
      ],
    };

    final totalPrice = (car['price'] as double) + (_withDriver ? (car['driverPrice'] as double) : 0.0);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Car Details',
        showBackButton: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ImageCarousel(
                  images: car['images'] as List<String>,
                  height: 280,
                  borderRadius: 0,
                ),

                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        car['name'] as String,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        '${car['brand']} ${car['model']} • ${car['year']}',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),

                      const SizedBox(height: 12),

                      RatingWidget(
                        rating: car['rating'] as double,
                        reviewCount: car['reviewCount'] as int?,
                        size: 18,
                      ),

                      const SizedBox(height: 20),

                      // Specifications
                      Text(
                        'Specifications',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _SpecItem(
                              icon: Icons.airline_seat_recline_normal_rounded,
                              label: 'Seats',
                              value: '${car['seats']}',
                            ),
                          ),
                          Expanded(
                            child: _SpecItem(
                              icon: Icons.settings_rounded,
                              label: 'Transmission',
                              value: car['transmission'] as String,
                            ),
                          ),
                          Expanded(
                            child: _SpecItem(
                              icon: Icons.local_gas_station_rounded,
                              label: 'Fuel',
                              value: car['fuelType'] as String,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      Text(
                        'Description',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        car['description'] as String,
                        style: TextStyle(fontSize: 14, color: Colors.grey[700], height: 1.6),
                      ),

                      const SizedBox(height: 20),

                      Text(
                        'Features',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: (car['features'] as List<String>)
                            .map((f) => Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFC89B3C).withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.check_circle,
                                        color: Color(0xFFC89B3C),
                                        size: 16,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        f,
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ))
                            .toList(),
                      ),

                      const SizedBox(height: 20),

                      // Driver Option
                      RoundedCard(
                        child: CheckboxListTile(
                          title: const Text('Add Professional Driver'),
                          subtitle: Text(
                            '+\$${car['driverPrice'] as double}/day',
                            style: const TextStyle(
                              color: Color(0xFFC89B3C),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          value: _withDriver,
                          onChanged: (value) {
                            setState(() => _withDriver = value ?? false);
                          },
                          activeColor: const Color(0xFFC89B3C),
                          contentPadding: EdgeInsets.zero,
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Total per day', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                        const SizedBox(height: 4),
                        PriceTag(price: totalPrice, unit: 'day', large: true),
                      ],
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: PrimaryButton(
                        label: 'Rent Now',
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

class _SpecItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _SpecItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFFC89B3C), size: 24),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}