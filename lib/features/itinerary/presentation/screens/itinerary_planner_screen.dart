import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/l10n.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/rounded_card.dart';
import '../../../marketplace/domain/models/marketplace_listing.dart';
import '../../../marketplace/presentation/providers/marketplace_providers.dart';
import '../providers/itinerary_providers.dart';

class ItineraryPlannerScreen extends ConsumerWidget {
  const ItineraryPlannerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final entries = ref.watch(itineraryEntriesProvider);
    final catalog = ref.watch(marketplaceCatalogProvider);
    final totalSpend = entries.fold<double>(0, (sum, entry) {
      final match = catalog.where((listing) => listing.id == entry.listingId);
      if (match.isEmpty) return sum;
      return sum + match.first.price;
    });

    return Scaffold(
      appBar: CustomAppBar(
        title: l10n.itineraryTitle,
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
                  l10n.itinerarySummary,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                ),
                const SizedBox(height: 8),
                Text('${entries.length} planned stops'),
                const SizedBox(height: 4),
                Text(
                  '${l10n.estimatedSpend}: \$${totalSpend.toStringAsFixed(0)}',
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          if (entries.isEmpty)
            RoundedCard(
              child: Column(
                children: [
                  Text(l10n.itineraryEmpty),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: () => context.push('/search'),
                    child: Text(l10n.startExploring),
                  ),
                ],
              ),
            )
          else
            ...entries.map((entry) {
              final listing = catalog.where((item) => item.id == entry.listingId);
              if (listing.isEmpty) {
                return const SizedBox.shrink();
              }
              final resolved = listing.first;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: RoundedCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Day ${entry.day}',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(resolved.title),
                      Text('${resolved.category.label} • ${resolved.city}'),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: FilledButton.tonal(
                              onPressed: () => context.push(
                                '/marketplace/listing/${resolved.category.name}/${resolved.id}',
                              ),
                              child: const Text('Open'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => ref
                                  .read(itineraryEntriesProvider.notifier)
                                  .removeListing(entry.listingId),
                              child: const Text('Remove'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }
}
