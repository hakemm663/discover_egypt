import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/l10n.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/network_image_fallback.dart';
import '../../../../core/widgets/rounded_card.dart';
import '../../../itinerary/presentation/providers/itinerary_providers.dart';
import '../../../marketplace/domain/models/marketplace_listing.dart';
import '../../../marketplace/presentation/providers/marketplace_providers.dart';

class ListingDetailPage extends ConsumerWidget {
  const ListingDetailPage({
    required this.listingId,
    required this.category,
    super.key,
  });

  final String listingId;
  final String category;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final listing = ref.watch(marketplaceListingProvider(listingId));
    final favorites = ref.watch(favoriteListingIdsProvider);

    if (listing == null) {
      return Scaffold(
        appBar: CustomAppBar(title: l10n.listingDetails),
        body: const Center(child: Text('Listing not found.')),
      );
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: listing.title,
        showBackButton: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: SizedBox(
              height: 260,
              child: NetworkImageFallback(
                imageUrl: listing.primaryImage,
                type: NetworkImageFallbackType.tour,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      listing.title,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w900,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text('${listing.location} • ${listing.city}'),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => ref
                    .read(favoriteListingIdsProvider.notifier)
                    .toggle(listing.id),
                icon: Icon(
                  favorites.contains(listing.id)
                      ? Icons.favorite
                      : Icons.favorite_border,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: listing.tags
                .map((tag) => Chip(label: Text(tag)))
                .toList(growable: false),
          ),
          const SizedBox(height: 20),
          RoundedCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(listing.description),
                const SizedBox(height: 16),
                Text(
                  'Rating ${listing.rating.toStringAsFixed(1)} (${listing.reviewCount} reviews)',
                ),
                const SizedBox(height: 8),
                Text('Cancellation: ${listing.cancellationPolicy}'),
                const SizedBox(height: 8),
                Text('Hosted by ${listing.vendorName}'),
              ],
            ),
          ),
          const SizedBox(height: 20),
          RoundedCard(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '\$${listing.price.toStringAsFixed(0)}',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w900,
                            ),
                      ),
                      Text('${listing.currency} per booking unit'),
                    ],
                  ),
                ),
                FilledButton.icon(
                  onPressed: () => ref
                      .read(itineraryEntriesProvider.notifier)
                      .addListing(listing.id),
                  icon: const Icon(Icons.route_outlined),
                  label: Text(l10n.saveToTrip),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed:
                listing.category.isBookable ? () => context.push('/booking-summary') : null,
            child: Text(listing.category.isBookable ? l10n.bookNow : category),
          ),
        ],
      ),
    );
  }
}
