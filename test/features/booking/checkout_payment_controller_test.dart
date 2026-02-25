import 'package:discover_egypt/features/booking/checkout_payment_controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('controller remains as deprecated compatibility shim', () {
    const controller = CheckoutPaymentController();
    expect(controller, isA<CheckoutPaymentController>());
  });
}
