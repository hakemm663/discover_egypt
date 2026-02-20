import 'package:flutter_test/flutter_test.dart';
import 'package:discover_egypt/features/booking/checkout_payment_controller.dart';

void main() {
  CheckoutCardInput validInput({
    String cardNumber = '4242 4242 4242 4242',
    String expiry = '12/30',
    String cvv = '123',
    String cardholderName = 'John Doe',
    bool saveCardRequested = false,
  }) {
    return CheckoutCardInput(
      cardNumber: cardNumber,
      expiry: expiry,
      cvv: cvv,
      cardholderName: cardholderName,
      saveCardRequested: saveCardRequested,
    );
  }

  group('CheckoutPaymentController.validateCardInput', () {
    final controller = CheckoutPaymentController(
      nowProvider: () => DateTime(2026, 1, 1),
    );

    test('returns success for valid 16-digit card and 3-digit CVV', () {
      final result = controller.validateCardInput(validInput());

      expect(result.isValid, isTrue);
      expect(result.failure, isNull);
    });

    test('accepts 4-digit CVV', () {
      final result = controller.validateCardInput(validInput(cvv: '1234'));

      expect(result.isValid, isTrue);
    });

    test('returns missingCardNumber when card number is empty', () {
      final result = controller.validateCardInput(validInput(cardNumber: ''));

      expect(result.failure?.error, CheckoutValidationError.missingCardNumber);
      expect(result.failure?.message, 'Card number is required.');
    });

    test('returns invalidCardNumberFormat when card contains letters', () {
      final result = controller.validateCardInput(
        validInput(cardNumber: '4242 42A2 4242 4242'),
      );

      expect(
        result.failure?.error,
        CheckoutValidationError.invalidCardNumberFormat,
      );
      expect(result.failure?.message, 'Card number must contain digits only.');
    });

    test('returns invalidCardNumberLength for non-16-digit card', () {
      final result = controller.validateCardInput(
        validInput(cardNumber: '4242 4242 4242'),
      );

      expect(
        result.failure?.error,
        CheckoutValidationError.invalidCardNumberLength,
      );
      expect(result.failure?.message, 'Card number must be 16 digits.');
    });

    test('returns invalidExpiryFormat when separator is missing', () {
      final result = controller.validateCardInput(validInput(expiry: '1230'));

      expect(result.failure?.error, CheckoutValidationError.invalidExpiryFormat);
      expect(result.failure?.message, 'Expiry date must use MM/YY format.');
    });

    test('returns invalidExpiryDate when month is out of range', () {
      final result = controller.validateCardInput(validInput(expiry: '13/30'));

      expect(result.failure?.error, CheckoutValidationError.invalidExpiryDate);
      expect(
        result.failure?.message,
        'Expiry month must be between 01 and 12.',
      );
    });

    test('returns expiredCard when expiry is before current month', () {
      final result = controller.validateCardInput(validInput(expiry: '12/25'));

      expect(result.failure?.error, CheckoutValidationError.expiredCard);
      expect(result.failure?.message, 'Card has expired.');
    });

    test('returns invalidCvvFormat for non-digit CVV', () {
      final result = controller.validateCardInput(validInput(cvv: '1a3'));

      expect(result.failure?.error, CheckoutValidationError.invalidCvvFormat);
      expect(result.failure?.message, 'CVV must contain digits only.');
    });

    test('returns invalidCvvLength for 2-digit CVV', () {
      final result = controller.validateCardInput(validInput(cvv: '12'));

      expect(result.failure?.error, CheckoutValidationError.invalidCvvLength);
      expect(result.failure?.message, 'CVV must be 3 or 4 digits.');
    });

    test('returns missingCardholderName for empty name', () {
      final result = controller.validateCardInput(validInput(cardholderName: ''));

      expect(
        result.failure?.error,
        CheckoutValidationError.missingCardholderName,
      );
      expect(result.failure?.message, 'Cardholder name is required.');
    });

    test('returns saveCardNotSupported when save card is requested', () {
      final result = controller.validateCardInput(
        validInput(saveCardRequested: true),
      );

      expect(result.failure?.error, CheckoutValidationError.saveCardNotSupported);
      expect(result.failure?.message, 'Saving cards is not available yet.');
    });
  });
}
