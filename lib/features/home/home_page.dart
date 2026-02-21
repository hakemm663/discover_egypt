import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/constants/image_urls.dart';
import '../../core/widgets/error_widget.dart';
import '../../core/widgets/loading_widget.dart';
import '../../core/widgets/custom_app_bar.dart';
import '../../core/widgets/rounded_card.dart';
import '../../core/widgets/section_title.dart';
import '../../core/widgets/rating_widget.dart';
import '../../core/widgets/price_tag.dart';
import 'home_provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeDataAsync = ref.watch(homeDataProvider);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Discover Egypt',
        showBackButton: false,
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
          data: (homeData) => SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              _SearchBar(),

              const SizedBox(height: 20),

              // Hero Banner
              Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _HeroBanner(),
                  )
                  .animate()
                  .fadeIn(delay: 200.ms, duration: 500.ms)
                  .slideY(begin: 0.1),

              const SizedBox(height: 24),

              // Categories
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _CategoriesSection(),
              ).animate().fadeIn(delay: 300.ms, duration: 500.ms),

              const SizedBox(height: 24),

              // Featured Destinations
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _FeaturedDestinations(destinations: homeData.destinations),
              ),

              const SizedBox(height: 24),

              // Popular Hotels
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
                  children: homeData.hotels
                      .map(
                        (hotel) => Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: _HotelCard(
                            id: hotel['id'],
                            name: hotel['name'],
                            location: hotel['location'],
                            image: hotel['image'],
                            rating: hotel['rating'],
                            reviewCount: hotel['reviewCount'],
                            price: hotel['price'],
                          ),
                        ),
                      )
                      .toList(),
                ),
              ).animate().fadeIn(delay: 400.ms, duration: 500.ms),

              const SizedBox(height: 24),

              // Popular Tours
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
                  children: homeData.tours
                      .map(
                        (tour) => Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _TourCard(
                            id: tour['id'],
                            name: tour['name'],
                            duration: tour['duration'],
                            image: tour['image'],
                            rating: tour['rating'],
                            reviewCount: tour['reviewCount'],
                            price: tour['price'],
                          ),
                        ),
                      )
                      .toList(),
                ),
              ).animate().fadeIn(delay: 500.ms, duration: 500.ms),

              const SizedBox(height: 24),

              // Recommended for You
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _RecommendedForYou(tours: homeData.recommendedTours),
              ),

              const SizedBox(height: 32),

              // Trip Planner Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton(
                  onPressed: () {
                    context.push('/trip-planner');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFC89B3C),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text(
                    'Plan Your Trip',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        )),
      ),
    );
  }
}

// ==================== SEARCH BAR ====================

class _SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search for destinations, hotels, or tours',
          prefixIcon: Icon(Icons.search),
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
}

// ==================== HERO BANNER ====================

class _HeroBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/tours'),
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            fit: StackFit.expand,
            children: [
              CachedNetworkImage(
                imageUrl: Img.pyramidsSunset,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey[300],
                  child: const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFFC89B3C),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.7),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFC89B3C),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        '20% OFF',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.surface,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Explore the Wonders of Egypt',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.surface,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Book now and get special discounts',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 14,
                      ),
                    ),
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

// ==================== CATEGORIES SECTION ====================

class _CategoriesSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final categories = [
      {'icon': Icons.hotel_outlined, 'label': 'Hotels', 'route': '/hotels'},
      {'icon': Icons.tour_outlined, 'label': 'Tours', 'route': '/tours'},
      {
        'icon': Icons.directions_car_outlined,
        'label': 'Cars',
        'route': '/cars',
      },
      {
        'icon': Icons.restaurant_outlined,
        'label': 'Food',
        'route': '/restaurants',
      },
    ];

    return RoundedCard(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: categories.map((cat) {
          return _CategoryItem(
            icon: cat['icon'] as IconData,
            label: cat['label'] as String,
            onTap: () => context.push(cat['route'] as String),
          );
        }).toList(),
      ),
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _CategoryItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFFC89B3C).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: const Color(0xFFC89B3C), size: 28),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== HOTEL CARD ====================

class _HotelCard extends StatelessWidget {
  final String id;
  final String name;
  final String location;
  final String image;
  final double rating;
  final int reviewCount;
  final double price;

  const _HotelCard({
    required this.id,
    required this.name,
    required this.location,
    required this.image,
    required this.rating,
    required this.reviewCount,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    final isCompactDevice = MediaQuery.sizeOf(context).width < 360;
    final detailPadding = isCompactDevice ? 10.0 : 12.0;
    final titleFontSize = isCompactDevice ? 15.0 : 16.0;
    final locationFontSize = isCompactDevice ? 11.0 : 12.0;
    final detailsSpacing = isCompactDevice ? 6.0 : 8.0;

    return GestureDetector(
      onTap: () => context.push('/hotel/$id'),
      child: Container(
        width: 240,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              // Background Image
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image
                  AspectRatio(
                    aspectRatio: 3 / 2,
                    child: SizedBox(
                      width: double.infinity,
                      child: CachedNetworkImage(
                        imageUrl: image,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            Container(color: Colors.grey[300]),
                      ),
                    ),
                  ),

                  // Details
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(detailPadding),
                      color: Theme.of(context).colorScheme.surface,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: TextStyle(
                              fontSize: titleFontSize,
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: isCompactDevice ? 2 : 4),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                size: 14,
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  location,
                                  style: TextStyle(
                                    fontSize: locationFontSize,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                  Container(
                    padding: const EdgeInsets.all(12),
                    color: Theme.of(context).colorScheme.surface,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 14,
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                location,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: detailsSpacing),
                          Expanded(
                            child: Row(
                              children: [
                                Flexible(
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    alignment: Alignment.centerLeft,
                                    child: RatingWidget(
                                      rating: rating,
                                      reviewCount: reviewCount,
                                      size: 14,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        '\$${price.toStringAsFixed(0)}/night',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: isCompactDevice ? 16 : 18,
                                          fontWeight: FontWeight.w800,
                                          color: const Color(0xFFC89B3C),
                                        ),
                                      ),
                                    ),
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

              // Favorite Button
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.9),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.favorite_border_rounded,
                    color: Color(0xFFC89B3C),
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==================== TOUR CARD ====================

class _TourCard extends StatelessWidget {
  final String id;
  final String name;
  final String duration;
  final String image;
  final double rating;
  final int reviewCount;
  final double price;

  const _TourCard({
    required this.id,
    required this.name,
    required this.duration,
    required this.image,
    required this.rating,
    required this.reviewCount,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/tour/$id'),
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
                  imageUrl: image,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      Container(color: Colors.grey[300]),
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
                      name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          size: 14,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            duration,
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    RatingWidget(
                      rating: rating,
                      reviewCount: reviewCount,
                      size: 14,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        PriceTag(price: price),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFFC89B3C,
                            ).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Book Now',
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

// ==================== FEATURED DESTINATIONS ====================

class _FeaturedDestinations extends StatelessWidget {
  final List<Map<String, dynamic>> destinations;

  const _FeaturedDestinations({required this.destinations});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Featured Destinations',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 200,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: destinations
                .map(
                  (destination) => Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: _DestinationCard(
                      name: destination['name'],
                      image: destination['image'],
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}

class _DestinationCard extends StatelessWidget {
  final String name;
  final String image;

  const _DestinationCard({required this.name, required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: image,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(color: Colors.grey[300]),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.7),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.surface,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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

// ==================== RECOMMENDED FOR YOU ====================

class _RecommendedForYou extends StatelessWidget {
  final List<Map<String, dynamic>> tours;

  const _RecommendedForYou({required this.tours});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Recommended for You',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: tours
                .map(
                  (tour) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _TourCard(
                      id: tour['id'],
                      name: tour['name'],
                      duration: tour['duration'],
                      image: tour['image'],
                      rating: tour['rating'],
                      reviewCount: tour['reviewCount'],
                      price: tour['price'],
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}
