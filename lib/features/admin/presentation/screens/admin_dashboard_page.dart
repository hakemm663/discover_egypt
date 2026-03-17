import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/localization/l10n.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/rounded_card.dart';
import '../../../marketplace/domain/models/marketplace_listing.dart';
import '../../../vendor/domain/models/vendor_listing_draft.dart';
import '../../../vendor/presentation/providers/vendor_dashboard_providers.dart';

class AdminDashboardPage extends ConsumerWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendingListings = ref
        .watch(vendorListingsProvider)
        .where((listing) => listing.status == VendorListingStatus.pendingApproval)
        .toList(growable: false);

    return Scaffold(
      appBar: CustomAppBar(
        title: context.l10n.adminDashboardTitle,
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
                  context.l10n.approvalQueue,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                ),
                const SizedBox(height: 8),
                Text('${pendingListings.length} listings need review.'),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ...pendingListings.map(
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
                    const SizedBox(height: 4),
                    Text('${listing.category.label} • ${listing.city}'),
                    const SizedBox(height: 8),
                    Text(listing.description),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => ref
                                .read(vendorListingsProvider.notifier)
                                .updateStatus(
                                  listing.id,
                                  VendorListingStatus.draft,
                                ),
                            child: const Text('Send back'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: FilledButton(
                            onPressed: () => ref
                                .read(vendorListingsProvider.notifier)
                                .updateStatus(
                                  listing.id,
                                  VendorListingStatus.approved,
                                ),
                            child: const Text('Approve'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (pendingListings.isEmpty)
            RoundedCard(
              child: Text(context.l10n.reviewInAdmin),
            ),
        ],
      ),
    );
  }
}
