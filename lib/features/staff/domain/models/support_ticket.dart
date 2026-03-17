enum SupportTicketPriority { low, medium, high }

enum SupportTicketStatus { newTicket, inProgress, resolved }

class SupportTicket {
  const SupportTicket({
    required this.id,
    required this.subject,
    required this.requesterName,
    required this.channel,
    required this.priority,
    required this.status,
  });

  final String id;
  final String subject;
  final String requesterName;
  final String channel;
  final SupportTicketPriority priority;
  final SupportTicketStatus status;

  SupportTicket copyWith({
    SupportTicketStatus? status,
  }) {
    return SupportTicket(
      id: id,
      subject: subject,
      requesterName: requesterName,
      channel: channel,
      priority: priority,
      status: status ?? this.status,
    );
  }
}
