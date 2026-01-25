import 'package:cloud_firestore/cloud_firestore.dart';

enum BookingStatus { pending, confirmed, completed, cancelled, refunded }

enum BookingType { hotel, tour, car, restaurant }

class BookingModel {
  final String id;
  final String userId;
  final String itemId; // hotel/tour/car/restaurant ID
  final BookingType type;
  final BookingStatus status;
  final String itemName;
  final String itemImage;
  final DateTime startDate;
  final DateTime endDate;
  final int guestCount;
  final double subtotal;
  final double serviceFee;
  final double taxes;
  final double discount;
  final double total;
  final String currency;
  final String paymentId;
  final String paymentMethod;
  final bool isPaid;
  final String? notes;
  final String? cancellationReason;
  final DateTime createdAt;
  final DateTime? paidAt;
  final DateTime? cancelledAt;

  BookingModel({
    required this.id,
    required this.userId,
    required this.itemId,
    required this.type,
    this.status = BookingStatus.pending,
    required this.itemName,
    required this.itemImage,
    required this.startDate,
    required this.endDate,
    this.guestCount = 1,
    required this.subtotal,
    required this.serviceFee,
    this.taxes = 0.0,
    this.discount = 0.0,
    required this.total,
    this.currency = 'USD',
    this.paymentId = '',
    this.paymentMethod = '',
    this.isPaid = false,
    this.notes,
    this.cancellationReason,
    required this.createdAt,
    this.paidAt,
    this.cancelledAt,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      itemId: json['itemId'] ?? '',
      type: BookingType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => BookingType.hotel,
      ),
      status: BookingStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => BookingStatus.pending,
      ),
      itemName: json['itemName'] ?? '',
      itemImage: json['itemImage'] ?? '',
      startDate: json['startDate'] is Timestamp
          ? (json['startDate'] as Timestamp).toDate()
          : DateTime.parse(json['startDate'] ?? DateTime.now().toIso8601String()),
      endDate: json['endDate'] is Timestamp
          ? (json['endDate'] as Timestamp).toDate()
          : DateTime.parse(json['endDate'] ?? DateTime.now().toIso8601String()),
      guestCount: json['guestCount'] ?? 1,
      subtotal: (json['subtotal'] ?? 0).toDouble(),
      serviceFee: (json['serviceFee'] ?? 0).toDouble(),
      taxes: (json['taxes'] ?? 0).toDouble(),
      discount: (json['discount'] ?? 0).toDouble(),
      total: (json['total'] ?? 0).toDouble(),
      currency: json['currency'] ?? 'USD',
      paymentId: json['paymentId'] ?? '',
      paymentMethod: json['paymentMethod'] ?? '',
      isPaid: json['isPaid'] ?? false,
      notes: json['notes'],
      cancellationReason: json['cancellationReason'],
      createdAt: json['createdAt'] is Timestamp
          ? (json['createdAt'] as Timestamp).toDate()
          : DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      paidAt: json['paidAt'] != null
          ? (json['paidAt'] is Timestamp
              ? (json['paidAt'] as Timestamp).toDate()
              : DateTime.parse(json['paidAt']))
          : null,
      cancelledAt: json['cancelledAt'] != null
          ? (json['cancelledAt'] is Timestamp
              ? (json['cancelledAt'] as Timestamp).toDate()
              : DateTime.parse(json['cancelledAt']))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'itemId': itemId,
      'type': type.name,
      'status': status.name,
      'itemName': itemName,
      'itemImage': itemImage,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'guestCount': guestCount,
      'subtotal': subtotal,
      'serviceFee': serviceFee,
      'taxes': taxes,
      'discount': discount,
      'total': total,
      'currency': currency,
      'paymentId': paymentId,
      'paymentMethod': paymentMethod,
      'isPaid': isPaid,
      'notes': notes,
      'cancellationReason': cancellationReason,
      'createdAt': Timestamp.fromDate(createdAt),
      'paidAt': paidAt != null ? Timestamp.fromDate(paidAt!) : null,
      'cancelledAt': cancelledAt != null ? Timestamp.fromDate(cancelledAt!) : null,
    };
  }

  String get formattedTotal => '\$$total';

  int get nights => endDate.difference(startDate).inDays;

  bool get canCancel =>
      status == BookingStatus.pending || status == BookingStatus.confirmed;
}