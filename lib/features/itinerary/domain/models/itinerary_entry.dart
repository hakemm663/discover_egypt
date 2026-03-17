class ItineraryEntry {
  const ItineraryEntry({
    required this.listingId,
    required this.day,
    this.note = '',
  });

  final String listingId;
  final int day;
  final String note;

  ItineraryEntry copyWith({
    String? listingId,
    int? day,
    String? note,
  }) {
    return ItineraryEntry(
      listingId: listingId ?? this.listingId,
      day: day ?? this.day,
      note: note ?? this.note,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'listingId': listingId,
      'day': day,
      'note': note,
    };
  }

  factory ItineraryEntry.fromJson(Map<String, dynamic> json) {
    return ItineraryEntry(
      listingId: json['listingId'] as String? ?? '',
      day: json['day'] as int? ?? 1,
      note: json['note'] as String? ?? '',
    );
  }
}
