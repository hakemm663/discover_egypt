import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../core/repositories/models/discovery_models.dart';
import '../../core/widgets/custom_app_bar.dart';
import '../../core/widgets/error_widget.dart';
import '../../core/widgets/loading_widget.dart';
import '../../core/widgets/price_tag.dart';
import '../../core/widgets/rating_widget.dart';
import '../../core/widgets/rounded_card.dart';
import 'tours_provider.dart';

class ToursListPage extends ConsumerStatefulWidget {
  const ToursListPage({super.key});

  @override
  ConsumerState<ToursListPage> createState() => _ToursListPageState();
}

class _ToursListPageState extends ConsumerState<ToursListPage> {
  String _selectedCategory = 'All';
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
    ref.read(toursQueryProvider.notifier).state = ToursQuery(category: _selectedCategory);
  }

  @override
  Widget build(BuildContext context) {
    final toursAsync = ref.watch(toursProvider);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Tours & Experiences', showBackButton: true),
      body: Column(
        children: [
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
                              _syncQuery();
                            },
                            selectedColor: const Color(0xFFC89B3C).withValues(alpha: 0.2),
                            checkmarkColor: const Color(0xFFC89B3C),
                          ),
                        ))
                    .toList(),
              ),
            ),
          ),
          Expanded(
            child: toursAsync.when(
              loading: () => const LoadingWidget(message: 'Loading tours...'),
              error: (error, stackTrace) => CustomErrorWidget(
                title: 'Could not load tours',
                message: error.toString(),
                onRetry: () => ref.invalidate(toursProvider),
              ),
              data: (toursPage) {
                final tours = toursPage.items;
                if (tours.isEmpty) {
                  return const EmptyStateWidget(title: 'No tours found');
                }
                return ListView.separated(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: tours.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final tour = tours[index];
                    return _TourListItem(tour: tour)
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

class _TourListItem extends StatelessWidget {
  final TourListing tour;

  const _TourListItem({required this.tour});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/tour/${tour.id}'),
      child: RoundedCard(
        padding: EdgeInsets.zero,
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
              child: SizedBox(
                width: 130,
                height: 160,
                child: CachedNetworkImage(
                  imageUrl: tour.image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFC89B3C).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        tour.category,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFC89B3C),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      tour.name,
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
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
                            tour.duration,
                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RatingWidget(rating: tour.rating, reviewCount: tour.reviewCount, size: 14),
                        PriceTag(price: tour.price),
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
