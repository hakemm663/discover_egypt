import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/l10n.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/rounded_card.dart';
import '../../../marketplace/domain/models/marketplace_listing.dart';
import '../../domain/models/vendor_listing_draft.dart';
import '../providers/vendor_dashboard_providers.dart';

class VendorDashboardPage extends ConsumerWidget {
  const VendorDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final listings = ref.watch(vendorListingsProvider);
    final draftCount =
        listings.where((listing) => listing.status == VendorListingStatus.draft).length;
    final pendingCount = listings
        .where((listing) => listing.status == VendorListingStatus.pendingApproval)
        .length;
    final approvedCount = listings
        .where((listing) => listing.status == VendorListingStatus.approved)
        .length;

    return Scaffold(
      appBar: CustomAppBar(
        title: l10n.vendorDashboardTitle,
        showBackButton: false,
        showProfileButton: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/vendor/listings/new'),
        icon: const Icon(Icons.add),
        label: Text(l10n.vendorCreateListing),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Row(
            children: [
              Expanded(
                child: _MetricCard(label: l10n.vendorDraft, value: '$draftCount'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _MetricCard(
                  label: l10n.vendorPendingApproval,
                  value: '$pendingCount',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _MetricCard(
                  label: l10n.vendorApproved,
                  value: '$approvedCount',
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            l10n.vendorListings,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
          ),
          const SizedBox(height: 12),
          ...listings.map(
            (listing) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: RoundedCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      listing.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    const SizedBox(height: 6),
                    Text('${listing.category.label} • ${listing.location}'),
                    const SizedBox(height: 6),
                    Text(_statusLabel(context, listing.status)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => context.push(
                              '/vendor/listings/${listing.id}/edit',
                            ),
                            child: const Text('Edit'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: FilledButton(
                            onPressed: listing.status == VendorListingStatus.approved
                                ? null
                                : () => ref
                                    .read(vendorListingsProvider.notifier)
                                    .submitForReview(listing.id),
                            child: Text(
                              listing.status == VendorListingStatus.approved
                                  ? context.l10n.approvedStatus
                                  : context.l10n.submitForReview,
                            ),
                          ),
                        ),
                      ],
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

  String _statusLabel(BuildContext context, VendorListingStatus status) {
    switch (status) {
      case VendorListingStatus.draft:
        return context.l10n.draftStatus;
      case VendorListingStatus.pendingApproval:
        return context.l10n.pendingStatus;
      case VendorListingStatus.approved:
        return context.l10n.approvedStatus;
    }
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return RoundedCard(
      child: Column(
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
          ),
          const SizedBox(height: 6),
          Text(label, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
