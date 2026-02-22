import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/image_urls.dart';
import '../../core/widgets/custom_app_bar.dart';
import '../../core/widgets/error_widget.dart';
import '../../core/widgets/loading_widget.dart';
import '../../core/widgets/network_image_fallback.dart';
import '../../core/widgets/price_tag.dart';
import '../../core/widgets/rating_widget.dart';
import '../../core/widgets/rounded_card.dart';
import '../../core/widgets/section_title.dart';
import '../shared/models/catalog_models.dart';
import 'home_provider.dart';

const _categories = <HomeCategoryItem>[
  HomeCategoryItem(
      icon: Icons.hotel_outlined, label: 'Hotels', route: '/hotels'),
  HomeCategoryItem(icon: Icons.tour_outlined, label: 'Tours', route: '/tours'),
  HomeCategoryItem(
      icon: Icons.directions_car_outlined, label: 'Cars', route: '/cars'),
  HomeCategoryItem(
      icon: Icons.restaurant_outlined, label: 'Food', route: '/restaurants'),
];

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeDataAsync = ref.watch(homeDataProvider);

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Discover Egypt',
        showBackButton: true,
        showMenuButton: true,
        showProfileButton: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(homeDataProvider);
          await ref.read(homeDataProvider.future);
        },
        color: const Color(0xFFC89B3C),
        child: homeDataAsync.when(
          loading: () => const LoadingWidget(message: 'Loading home data...'),
          error: (error, stackTrace) => CustomErrorWidget(
            title: 'Failed to load home data',
            message: error.toString(),
            onRetry: () => ref.invalidate(homeDataProvider),
          ),
          data: (_) => SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _SearchBar(),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: _HeroBanner(),
                )
                    .animate()
                    .fadeIn(delay: 200.ms, duration: 500.ms)
                    .slideY(begin: 0.1),
                const SizedBox(height: 24),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: _CategoriesSection(),
                ).animate().fadeIn(delay: 300.ms, duration: 500.ms),
                const SizedBox(height: 24),
                _FeaturedDestinations(
                    destinations: ref.watch(homeDestinationsProvider)),
                const SizedBox(height: 24),
                _PopularHotelsSection(hotels: ref.watch(homeHotelsProvider)),
                const SizedBox(height: 24),
                _PopularToursSection(tours: ref.watch(homeToursProvider)),
                const SizedBox(height: 24),
                _RecommendedForYou(
                    tours: ref.watch(homeRecommendedToursProvider)),
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ElevatedButton(
                    onPressed: () => context.push('/trip-planner'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFC89B3C),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                    ),
                    child: const Text('Plan Your Trip',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar();
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Search for destinations, hotels, or tours',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.grey[200],
          ),
        ),
      );
}

class _HeroBanner extends StatelessWidget {
  const _HeroBanner();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/tours'),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: SizedBox(
          height: 180,
          child: Stack(
            fit: StackFit.expand,
            children: [
              NetworkImageFallback(
                imageUrl: Img.pyramidsSunset,
                type: NetworkImageFallbackType.tour,
                fit: BoxFit.cover,
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.7)
                    ],
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _PromoBadge(),
                    SizedBox(height: 8),
                    Text('Explore the Wonders of Egypt',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w800)),
                    SizedBox(height: 4),
                    Text('Book now and get special discounts',
                        style: TextStyle(color: Colors.white, fontSize: 14)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PromoBadge extends StatelessWidget {
  const _PromoBadge();

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
            color: const Color(0xFFC89B3C),
            borderRadius: BorderRadius.circular(20)),
        child: const Text('20% OFF',
            style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w700)),
      );
}

class _CategoriesSection extends StatelessWidget {
  const _CategoriesSection();
  @override
  Widget build(BuildContext context) => RoundedCard(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: _categories
              .map((cat) => _CategoryItem(
                  icon: cat.icon,
                  label: cat.label,
                  onTap: () => context.push(cat.route)))
              .toList(),
        ),
      );
}

class _CategoryItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _CategoryItem(
      {required this.icon, required this.label, required this.onTap});
  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        child: Column(
          children: [
            Icon(icon, size: 32, color: const Color(0xFFC89B3C)),
            const SizedBox(height: 8),
            Text(label,
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
          ],
        ),
      );
}

class _PopularHotelsSection extends StatelessWidget {
  final List<HotelListItem> hotels;
  const _PopularHotelsSection({required this.hotels});

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SectionTitle(
              title: 'Popular Hotels',
              trailing: 'View All',
              trailingIcon: Icons.arrow_forward_ios_rounded,
              onTrailingTap: () => context.push('/hotels'),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 260,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: hotels
                  .map((hotel) => Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: _HotelCard(hotel: hotel),
                      ))
                  .toList(),
            ),
          ),
        ],
      );
}

class _PopularToursSection extends StatelessWidget {
  final List<TourListItem> tours;
  const _PopularToursSection({required this.tours});

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SectionTitle(
              title: 'Popular Tours',
              trailing: 'View All',
              trailingIcon: Icons.arrow_forward_ios_rounded,
              onTrailingTap: () => context.push('/tours'),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
                children: tours
                    .map((tour) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _TourCard(tour: tour)))
                    .toList()),
          ),
        ],
      );
}

class _HotelCard extends StatelessWidget {
  final HotelListItem hotel;
  const _HotelCard({required this.hotel});
  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => context.push('/hotel/${hotel.id}'),
        child: SizedBox(
          width: 240,
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: SizedBox(
                  height: 160,
                  width: double.infinity,
                  child: CachedNetworkImage(
                      imageUrl: hotel.image, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(height: 8),
              Text(hotel.name,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(hotel.location,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RatingWidget(
                      rating: hotel.rating,
                      reviewCount: hotel.reviewCount,
                      size: 14),
                  PriceTag(price: hotel.price, unit: 'night'),
                ],
              ),
            ],
          ),
        ),
      );
}

class _TourCard extends StatelessWidget {
  final TourListItem tour;
  const _TourCard({required this.tour});
  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => context.push('/tour/${tour.id}'),
        child: RoundedCard(
          padding: EdgeInsets.zero,
          child: Row(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20)),
                child: SizedBox(
                  width: 120,
                  height: 140,
                  child: CachedNetworkImage(
                      imageUrl: tour.image, fit: BoxFit.cover),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(tour.name,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text(tour.duration,
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 12)),
                      const SizedBox(height: 8),
                      RatingWidget(
                          rating: tour.rating,
                          reviewCount: tour.reviewCount,
                          size: 14),
                      const SizedBox(height: 8),
                      PriceTag(price: tour.price),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}

class _FeaturedDestinations extends StatelessWidget {
  final List<DestinationItem> destinations;

  const _FeaturedDestinations({required this.destinations});
  @override
  Widget build(BuildContext context) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SectionTitle(
              title: 'Featured Destinations',
              trailing: 'View All',
              trailingIcon: Icons.arrow_forward_ios_rounded,
              onTrailingTap: () {},
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 200,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: destinations
                  .map((destination) => Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: _DestinationCard(
                            name: destination.name, image: destination.image),
                      ))
                  .toList(),
            ),
          ),
        ],
      );
}

class _DestinationCard extends StatelessWidget {
  final String name;
  final String image;
  const _DestinationCard({required this.name, required this.image});
  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: SizedBox(
          width: 160,
          child: Stack(
            fit: StackFit.expand,
            children: [
              NetworkImageFallback(
                  imageUrl: image,
                  type: NetworkImageFallbackType.tour,
                  fit: BoxFit.cover),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.7)
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(name,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      );
}

class _RecommendedForYou extends StatelessWidget {
  final List<TourListItem> tours;

  const _RecommendedForYou({required this.tours});
  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text('Recommended for You',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: tours
                  .map((tour) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _TourCard(tour: tour)))
                  .toList(),
            ),
          ),
        ],
      );
}
