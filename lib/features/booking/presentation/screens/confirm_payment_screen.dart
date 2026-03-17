import 'package:flutter/widgets.dart';

import '../../booking_checkout_data.dart';
import '../../confirm_pay_page.dart';

class ConfirmPaymentScreen extends StatelessWidget {
  const ConfirmPaymentScreen({
    required this.checkoutData,
    super.key,
  });

  final BookingCheckoutData checkoutData;

  @override
  Widget build(BuildContext context) {
    return ConfirmPayPage(checkoutData: checkoutData);
  }
}
