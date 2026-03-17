import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/localization/l10n.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/rounded_card.dart';
import '../../domain/models/support_ticket.dart';
import '../providers/staff_dashboard_providers.dart';

class StaffDashboardPage extends ConsumerWidget {
  const StaffDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tickets = ref.watch(supportTicketsProvider);

    return Scaffold(
      appBar: CustomAppBar(
        title: context.l10n.staffDashboardTitle,
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
                  context.l10n.supportTickets,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                ),
                const SizedBox(height: 8),
                Text('${tickets.length} active operations tickets'),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ...tickets.map(
            (ticket) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: RoundedCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ticket.subject,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text('${ticket.requesterName} • ${ticket.channel}'),
                    const SizedBox(height: 8),
                    Text(
                      'Priority: ${ticket.priority.name} • Status: ${ticket.status.name}',
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: ticket.status == SupportTicketStatus.newTicket
                                ? () => ref
                                    .read(supportTicketsProvider.notifier)
                                    .updateStatus(
                                      ticket.id,
                                      SupportTicketStatus.inProgress,
                                    )
                                : null,
                            child: Text(context.l10n.moveToInProgress),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: FilledButton(
                            onPressed: ticket.status == SupportTicketStatus.resolved
                                ? null
                                : () => ref
                                    .read(supportTicketsProvider.notifier)
                                    .updateStatus(
                                      ticket.id,
                                      SupportTicketStatus.resolved,
                                    ),
                            child: Text(context.l10n.resolveTicket),
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
}
