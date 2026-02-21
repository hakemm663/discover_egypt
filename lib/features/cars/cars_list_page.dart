import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/widgets/custom_app_bar.dart';
import '../../core/widgets/rounded_card.dart';
import '../../core/widgets/rating_widget.dart';
import '../../core/widgets/price_tag.dart';
import '../../core/widgets/error_widget.dart';
import '../../core/widgets/loading_widget.dart';
import '../../core/widgets/network_image_fallback.dart';
import 'cars_provider.dart';

class CarsListPage extends ConsumerStatefulWidget {
  const CarsListPage({super.key});

  @override
  ConsumerState<CarsListPage> createState() => _CarsListPageState();
}

class _CarsListPageState extends ConsumerState<CarsListPage> {
  String _selectedType = 'All';
  bool _withDriverOnly = false;

  List<Map<String, dynamic>> _filteredCars(List<Map<String, dynamic>> sourceCars) {
    var cars = [...sourceCars];

    if (_selectedType != 'All') {
      cars = cars.where((c) => c['type'] == _selectedType).toList();
    }

    if (_withDriverOnly) {
      cars = cars.where((c) => c['withDriver'] == true).toList();
    }

    return cars;
  }

  @override
  Widget build(BuildContext context) {
    final carsAsync = ref.watch(carsProvider);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Car Rental',
        showBackButton: true,
      ),
      body: Column(
        children: [
          // Filters
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Type Filter
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: ['All', 'Sedan', 'SUV', 'Luxury', 'Van']
                        .map((type) => Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: FilterChip(
                                label: Text(type),
                                selected: _selectedType == type,
                                onSelected: (selected) {
                                  setState(() => _selectedType = type);
                                },
                                selectedColor: const Color(0xFFC89B3C).withValues(alpha: 0.2),
                                checkmarkColor: const Color(0xFFC89B3C),
                              ),
                            ))
                        .toList(),
                  ),
                ),
                const SizedBox(height: 8),
                // With Driver Toggle
                CheckboxListTile(
                  title: const Text('With Driver Only', style: TextStyle(fontSize: 14)),
                  value: _withDriverOnly,
                  onChanged: (value) {
                    setState(() => _withDriverOnly = value ?? false);
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                  activeColor: const Color(0xFFC89B3C),
                  contentPadding: EdgeInsets.zero,
                ),
              ],
            ),
          ),

          // Cars List
          Expanded(
            child: carsAsync.when(
              loading: () => const LoadingWidget(message: 'Loading cars...'),
              error: (error, stackTrace) => CustomErrorWidget(
                title: 'Could not load cars',
                message: error.toString(),
                onRetry: () => ref.invalidate(carsProvider),
              ),
              data: (cars) {
                final filteredCars = _filteredCars(cars);
                if (filteredCars.isEmpty) {
                  return const EmptyStateWidget(title: 'No cars found');
                }
                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredCars.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final car = filteredCars[index];
                    return _CarListItem(car: car)
                        .animate(delay: Duration(milliseconds: 100 * index))
                        .fadeIn(duration: 400.ms)
                        .slideX(begin: 0.2, end: 0);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CarListItem extends StatelessWidget {
  final Map<String, dynamic> car;

  const _CarListItem({required this.car});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/car/${car['id']}'),
      child: RoundedCard(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  child: Container(
                    height: 160,
                    width: double.infinity,
                    color: Colors.grey[100],
                    child: NetworkImageFallback(
                      imageUrl: car['image'],
                      type: NetworkImageFallbackType.car,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFC89B3C),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      car['type'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Details
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    car['name'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _InfoChip(
                        icon: Icons.airline_seat_recline_normal_rounded,
                        text: '${car['seats']} Seats',
                      ),
                      const SizedBox(width: 8),
                      _InfoChip(
                        icon: Icons.settings_rounded,
                        text: car['transmission'],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RatingWidget(
                        rating: car['rating'],
                        reviewCount: car['reviewCount'],
                        size: 16,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          PriceTag(price: car['price'], unit: 'day'),
                          if (car['withDriver'])
                            Text(
                              '+\$${car['driverPrice']}/day with driver',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey[600],
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoChip({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.grey[700]),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(fontSize: 12, color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }
}