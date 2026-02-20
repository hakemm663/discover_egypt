import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../core/models/booking_model.dart';

class CheckoutLineItem {
  final String label;
  final double amount;

  const CheckoutLineItem({
    required this.label,
    required this.amount,
  });
}

class CheckoutBookingModel {
  final String id;
  final String currency;
  final List<CheckoutLineItem> lineItems;
  final double serviceFee;
  final double taxes;

  const CheckoutBookingModel({
    required this.id,
    required this.currency,
    required this.lineItems,
    required this.serviceFee,
    required this.taxes,
  });

  double get subtotal =>
      lineItems.fold(0, (running, item) => running + item.amount);

  double get total => subtotal + serviceFee + taxes;

  factory CheckoutBookingModel.fromBookingModel(BookingModel booking) {
    return CheckoutBookingModel(
      id: booking.id,
      currency: booking.currency,
      lineItems: [
        CheckoutLineItem(
          label: booking.itemName,
          amount: booking.subtotal,
        ),
      ],
      serviceFee: booking.serviceFee,
      taxes: booking.taxes,
    );
  }
}

final currentCheckoutBookingProvider =
    StateProvider<CheckoutBookingModel?>((ref) => null);

final checkoutBookingDraftsProvider =
    StateProvider<Map<String, CheckoutBookingModel>>((ref) => {});

final checkoutBookingByIdProvider =
    FutureProvider.family<CheckoutBookingModel?, String>((ref, bookingId) async {
  final currentBooking = ref.read(currentCheckoutBookingProvider);
  if (currentBooking?.id == bookingId) {
    return currentBooking;
  }

  final draftBooking = ref.read(checkoutBookingDraftsProvider)[bookingId];
  if (draftBooking != null) {
    ref.read(currentCheckoutBookingProvider.notifier).state = draftBooking;
    return draftBooking;
  }

  final booking = await ref.read(databaseServiceProvider).getBookingById(bookingId);
  if (booking == null) {
    return null;
  }

  final checkoutBooking = CheckoutBookingModel.fromBookingModel(booking);
  ref.read(currentCheckoutBookingProvider.notifier).state = checkoutBooking;
  return checkoutBooking;
});
