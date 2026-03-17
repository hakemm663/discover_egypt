import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/support_ticket.dart';

final supportTicketsProvider =
    StateNotifierProvider<SupportTicketsNotifier, List<SupportTicket>>(
  (ref) => SupportTicketsNotifier(),
);

class SupportTicketsNotifier extends StateNotifier<List<SupportTicket>> {
  SupportTicketsNotifier()
      : super(const <SupportTicket>[
          SupportTicket(
            id: 'ticket_1',
            subject: 'Airport pickup timing changed',
            requesterName: 'Laila Hassan',
            channel: 'In-app chat',
            priority: SupportTicketPriority.high,
            status: SupportTicketStatus.newTicket,
          ),
          SupportTicket(
            id: 'ticket_2',
            subject: 'Vendor payout verification pending',
            requesterName: 'Nile Stay Collective',
            channel: 'Ops inbox',
            priority: SupportTicketPriority.medium,
            status: SupportTicketStatus.inProgress,
          ),
          SupportTicket(
            id: 'ticket_3',
            subject: 'Guide late arrival compensation request',
            requesterName: 'Matthew Cole',
            channel: 'Email',
            priority: SupportTicketPriority.high,
            status: SupportTicketStatus.newTicket,
          ),
        ]);

  void updateStatus(String ticketId, SupportTicketStatus status) {
    state = state
        .map((ticket) => ticket.id == ticketId ? ticket.copyWith(status: status) : ticket)
        .toList(growable: false);
  }
}
