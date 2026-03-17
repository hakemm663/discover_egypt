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

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final TextEditingController _queryController = TextEditingController();
  MarketplaceCategory? _selectedCategory;
  int _visibleCount = 6;

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final listings = ref.watch(marketplaceCatalogProvider);
    final favorites = ref.watch(favoriteListingIdsProvider);

    final query = _queryController.text.trim().toLowerCase();
    final filtered = listings.where((listing) {
      final matchesCategory =
          _selectedCategory == null || listing.category == _selectedCategory;
      final haystack = <String>[
        listing.title,
        listing.city,
        listing.location,
        listing.description,
        ...listing.tags,
      ].join(' ').toLowerCase();
      final matchesQuery = query.isEmpty || haystack.contains(query);
      return matchesCategory && matchesQuery;
    }).toList(growable: false);

    final visibleResults =
        filtered.take(_visibleCount).toList(growable: false);

    return Scaffold(
      appBar: CustomAppBar(
        title: l10n.searchTitle,
        showBackButton: false,
        showProfileButton: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: _queryController,
            onChanged: (_) => setState(() => _visibleCount = 6),
            decoration: InputDecoration(
              hintText: l10n.searchHint,
              prefixIcon: const Icon(Icons.search),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ChoiceChip(
                label: const Text('All'),
                selected: _selectedCategory == null,
                onSelected: (_) => setState(() => _selectedCategory = null),
              ),
              for (final category in MarketplaceCategory.values)
                ChoiceChip(
                  label: Text(category.label),
                  selected: _selectedCategory == category,
                  onSelected: (_) => setState(
                    () => _selectedCategory =
                        _selectedCategory == category ? null : category,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),
          if (visibleResults.isEmpty)
            RoundedCard(
              child: Text(l10n.searchEmpty),
            )
          else
            ...visibleResults.map(
              (listing) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: RoundedCard(
                  padding: EdgeInsets.zero,
                  child: InkWell(
                    onTap: () => context.push(
                      '/marketplace/listing/${listing.category.name}/${listing.id}',
                    ),
                    borderRadius: BorderRadius.circular(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                          child: SizedBox(
                            height: 180,
                            width: double.infinity,
                            child: NetworkImageFallback(
                              imageUrl: listing.primaryImage,
                              type: NetworkImageFallbackType.tour,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      listing.title,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w800,
                                          ),
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
                              Text('${listing.category.label} • ${listing.city}'),
                              const SizedBox(height: 8),
                              Text(
                                listing.description,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Text(
                                    '\$${listing.price.toStringAsFixed(0)}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.w900,
                                        ),
                                  ),
                                  const Spacer(),
                                  TextButton.icon(
                                    onPressed: () => ref
                                        .read(itineraryEntriesProvider.notifier)
                                        .addListing(listing.id),
                                    icon: const Icon(Icons.route_outlined),
                                    label: Text(l10n.saveToTrip),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          if (visibleResults.length < filtered.length)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: FilledButton(
                onPressed: () => setState(() => _visibleCount += 6),
                child: Text(l10n.loadMore),
              ),
            ),
        ],
      ),
    );
  }
}
