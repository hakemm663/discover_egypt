import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/repositories/models/discovery_models.dart';
import '../../core/widgets/custom_app_bar.dart';
import '../../core/widgets/error_widget.dart';
import '../../core/widgets/loading_widget.dart';
import '../../core/widgets/price_tag.dart';
import '../../core/widgets/rating_widget.dart';
import '../../core/widgets/rounded_card.dart';
import 'hotels_provider.dart';

class HotelsListPage extends ConsumerStatefulWidget {
  const HotelsListPage({super.key});

  @override
  ConsumerState<HotelsListPage> createState() => _HotelsListPageState();
}

class _HotelsListPageState extends ConsumerState<HotelsListPage> {
  String _selectedCity = 'All';
  String _sortBy = 'Popular';
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _syncQuery() {
    ref.read(hotelsQueryProvider.notifier).state = HotelsQuery(city: _selectedCity, sortBy: _sortBy);
  }

  @override
  Widget build(BuildContext context) {
    final hotelsAsync = ref.watch(hotelsProvider);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Hotels in Egypt', showBackButton: true),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: ['All', 'Cairo', 'Luxor', 'Hurghada', 'Alexandria']
                        .map((city) => Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: FilterChip(
                                label: Text(city),
                                selected: _selectedCity == city,
                                onSelected: (selected) {
                                  setState(() => _selectedCity = city);
                                  _syncQuery();
                                },
                                selectedColor: const Color(0xFFC89B3C).withValues(alpha: 0.2),
                                checkmarkColor: const Color(0xFFC89B3C),
                              ),
                            ))
                        .toList(),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.sort_rounded, size: 20),
                    const SizedBox(width: 8),
                    const Text('Sort by:', style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButton<String>(
                        value: _sortBy,
                        isExpanded: true,
                        underline: const SizedBox(),
                        items: ['Popular', 'Rating', 'Price: Low to High', 'Price: High to Low']
                            .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _sortBy = value);
                            _syncQuery();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: hotelsAsync.when(
              loading: () => const LoadingWidget(message: 'Loading hotels...'),
              error: (error, stackTrace) => CustomErrorWidget(
                title: 'Could not load hotels',
                message: error.toString(),
                onRetry: () => ref.invalidate(hotelsProvider),
              ),
              data: (hotelsPage) {
                final hotels = hotelsPage.items;
                if (hotels.isEmpty) {
                  return const EmptyStateWidget(title: 'No hotels found');
                }
                return ListView.separated(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: hotels.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) => _HotelListItem(hotel: hotels[index])
                      .animate(delay: Duration(milliseconds: 100 * index))
                      .fadeIn(duration: 400.ms)
                      .slideX(begin: 0.2, end: 0),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _HotelListItem extends StatelessWidget {
  final HotelListing hotel;

  const _HotelListItem({required this.hotel});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/hotel/${hotel.id}'),
      child: RoundedCard(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                  child: SizedBox(
                    height: 180,
                    width: double.infinity,
                    child: CachedNetworkImage(imageUrl: hotel.image, fit: BoxFit.cover),
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.9), shape: BoxShape.circle),
                    child: Icon(
                      hotel.isBookmarked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                      color: const Color(0xFFC89B3C),
                      size: 20,
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: const Color(0xFFC89B3C), borderRadius: BorderRadius.circular(8)),
                    child: Row(children: List.generate(hotel.stars, (i) => const Icon(Icons.star, color: Colors.white, size: 12))),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(hotel.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(hotel.location, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: hotel.amenities
                        .map((a) => Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8)),
                              child: Text(a, style: TextStyle(fontSize: 11, color: Colors.grey[700])),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RatingWidget(rating: hotel.rating, reviewCount: hotel.reviewCount, size: 16),
                      PriceTag(price: hotel.price, unit: 'night', large: true),
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

class EmptyStateWidget extends StatelessWidget {
  final String title;

  const EmptyStateWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        title,
        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
      ),
    );
  }
}
