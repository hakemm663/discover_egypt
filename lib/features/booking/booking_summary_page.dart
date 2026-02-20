import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/widgets/app_bar_widget.dart';
import '../../core/widgets/rounded_card.dart';
import '../../core/widgets/primary_button.dart';
import 'checkout_booking_state.dart';

class BookingSummaryPage extends ConsumerStatefulWidget {
  const BookingSummaryPage({super.key});

  @override
  ConsumerState<BookingSummaryPage> createState() => _BookingSummaryPageState();
}

class _BookingSummaryPageState extends ConsumerState<BookingSummaryPage> {
  DateTime _checkIn = DateTime.now().add(const Duration(days: 7));
  DateTime _checkOut = DateTime.now().add(const Duration(days: 10));
  int _guests = 2;

  double get _subtotal => 360.0;
  double get _serviceFee => 36.0;
  double get _taxes => 14.4;
  double get _total => _subtotal + _serviceFee + _taxes;

  void _proceedToPayment() {
    final bookingId = 'draft-${DateTime.now().millisecondsSinceEpoch}';
    final booking = CheckoutBookingModel(
      id: bookingId,
      currency: 'USD',
      lineItems: [
        CheckoutLineItem(
          label: 'Stay subtotal',
          amount: _subtotal,
        ),
      ],
      serviceFee: _serviceFee,
      taxes: _taxes,
    );

    ref.read(checkoutBookingDraftsProvider.notifier).update((state) {
      return {...state, bookingId: booking};
    });
    ref.read(currentCheckoutBookingProvider.notifier).state = booking;

    context.push('/confirm-pay?bookingId=$bookingId');
  }

  Future<void> _selectCheckIn() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _checkIn,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFC89B3C),
            ),
          ),
          child: child!,
        );
      },
    );
    if (date != null) {
      setState(() {
        _checkIn = date;
        if (_checkOut.isBefore(_checkIn)) {
          _checkOut = _checkIn.add(const Duration(days: 1));
        }
      });
    }
  }

  Future<void> _selectCheckOut() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _checkOut,
      firstDate: _checkIn.add(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFC89B3C),
            ),
          ),
          child: child!,
        );
      },
    );
    if (date != null) {
      setState(() => _checkOut = date);
    }
  }

  @override
  Widget build(BuildContext context) {
    final nights = _checkOut.difference(_checkIn).inDays;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Booking Summary',
        showBackButton: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Booking Details
                Text(
                  'Trip Details',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 16),

                RoundedCard(
                  child: Column(
                    children: [
                      // Check-in
                      _BookingRow(
                        label: 'Check-in',
                        value: DateFormat('MMM dd, yyyy').format(_checkIn),
                        icon: Icons.calendar_today_rounded,
                        onTap: _selectCheckIn,
                      ),
                      const Divider(height: 24),

                      // Check-out
                      _BookingRow(
                        label: 'Check-out',
                        value: DateFormat('MMM dd, yyyy').format(_checkOut),
                        icon: Icons.calendar_today_rounded,
                        onTap: _selectCheckOut,
                      ),
                      const Divider(height: 24),

                      // Nights
                      _BookingRow(
                        label: 'Nights',
                        value: '$nights night${nights > 1 ? 's' : ''}',
                        icon: Icons.nights_stay_rounded,
                      ),
                      const Divider(height: 24),

                      // Guests
                      Row(
                        children: [
                          Icon(Icons.people_rounded, size: 20, color: Colors.grey[600]),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Guests',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[700],
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: _guests > 1 ? () => setState(() => _guests--) : null,
                            icon: Icon(
                              Icons.remove_circle_outline,
                              color: _guests > 1 ? const Color(0xFFC89B3C) : Colors.grey,
                            ),
                          ),
                          Text(
                            '$_guests',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          IconButton(
                            onPressed: () => setState(() => _guests++),
                            icon: const Icon(
                              Icons.add_circle_outline,
                              color: Color(0xFFC89B3C),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Price Breakdown
                Text(
                  'Price Breakdown',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 16),

                RoundedCard(
                  child: Column(
                    children: [
                      _PriceRow(label: 'Subtotal', amount: _subtotal),
                      const SizedBox(height: 12),
                      _PriceRow(label: 'Service fee', amount: _serviceFee),
                      const SizedBox(height: 12),
                      _PriceRow(label: 'Taxes', amount: _taxes),
                      const Divider(height: 24),
                      _PriceRow(
                        label: 'Total',
                        amount: _total,
                        isTotal: true,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Cancellation Policy
                Text(
                  'Cancellation Policy',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 16),

                RoundedCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.info_outline_rounded, color: Colors.blue[600], size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Free cancellation',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Colors.blue[600],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Cancel up to 24 hours before check-in for a full refund.',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[700],
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 120), // Space for bottom bar
              ],
            ),
          ),

          // Bottom Bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '\$${_total.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFFC89B3C),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    PrimaryButton(
                      label: 'Proceed to Payment',
                      icon: Icons.payment_rounded,
                      onPressed: _proceedToPayment,
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

class _BookingRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final VoidCallback? onTap;

  const _BookingRow({
    required this.label,
    required this.value,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final row = Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
          ),
        ),
        if (onTap != null) ...[
          const SizedBox(width: 8),
          Icon(Icons.edit_outlined, size: 16, color: Colors.grey[600]),
        ],
      ],
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: row,
      );
    }

    return row;
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final double amount;
  final bool isTotal;

  const _PriceRow({
    required this.label,
    required this.amount,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.w800 : FontWeight.w600,
            color: isTotal ? Colors.black : Colors.grey[700],
          ),
        ),
        Text(
          '\$${amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: isTotal ? 18 : 15,
            fontWeight: FontWeight.w800,
            color: isTotal ? const Color(0xFFC89B3C) : Colors.black87,
          ),
        ),
      ],
    );
  }
}
