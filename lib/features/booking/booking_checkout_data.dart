import '../../core/models/booking_model.dart';

class BookingCheckoutData {
  const BookingCheckoutData({
    required this.itemId,
    required this.type,
    required this.itemName,
    required this.itemImage,
    required this.startDate,
    required this.endDate,
    required this.guestCount,
    required this.subtotal,
    required this.serviceFee,
    required this.taxes,
    required this.discount,
    required this.total,
    this.currency = 'USD',
  });

  final String itemId;
  final BookingType type;
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
}
