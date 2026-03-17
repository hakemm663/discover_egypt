import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/l10n.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/network_image_fallback.dart';
import '../../../../core/widgets/rounded_card.dart';
import '../../domain/models/marketplace_listing.dart';
import '../providers/marketplace_providers.dart';

class MarketplacePage extends ConsumerWidget {
  const MarketplacePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final featuredListings = ref.watch(featuredMarketplaceListingsProvider);

    return Scaffold(
      appBar: CustomAppBar(
        title: l10n.marketplaceTitle,
        showBackButton: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          RoundedCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.marketplaceTitle,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                ),
                const SizedBox(height: 8),
                Text(l10n.marketplaceSubtitle),
                const SizedBox(height: 12),
                Text(
                  l10n.bookableCategoriesNotice,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            l10n.browseByCategory,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            childAspectRatio: 1.35,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            children: [
              for (final category in MarketplaceCategory.values)
                RoundedCard(
                  child: InkWell(
                    onTap: () => context.push('/search'),
                    borderRadius: BorderRadius.circular(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(_iconFor(category), size: 30),
                        const SizedBox(height: 10),
                        Text(
                          category.label,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            l10n.featuredListings,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 12),
          ...featuredListings.map(
            (listing) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: RoundedCard(
                padding: EdgeInsets.zero,
                child: InkWell(
                  onTap: () => context.push(
                    '/marketplace/listing/${listing.category.name}/${listing.id}',
                  ),
                  borderRadius: BorderRadius.circular(20),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.horizontal(
                          left: Radius.circular(20),
                        ),
                        child: SizedBox(
                          width: 110,
                          height: 130,
                          child: NetworkImageFallback(
                            imageUrl: listing.primaryImage,
                            type: NetworkImageFallbackType.tour,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                listing.title,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w800),
                              ),
                              const SizedBox(height: 4),
                              Text('${listing.category.label} • ${listing.city}'),
                              const SizedBox(height: 12),
                              Text(
                                '\$${listing.price.toStringAsFixed(0)}',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w900),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _iconFor(MarketplaceCategory category) {
    switch (category) {
      case MarketplaceCategory.hotel:
        return Icons.hotel_outlined;
      case MarketplaceCategory.apartment:
        return Icons.apartment_outlined;
      case MarketplaceCategory.tour:
        return Icons.tour_outlined;
      case MarketplaceCategory.car:
        return Icons.directions_car_outlined;
      case MarketplaceCategory.guide:
        return Icons.badge_outlined;
      case MarketplaceCategory.attraction:
        return Icons.confirmation_number_outlined;
      case MarketplaceCategory.restaurant:
        return Icons.restaurant_outlined;
    }
  }
}
