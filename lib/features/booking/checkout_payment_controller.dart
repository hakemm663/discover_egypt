class CheckoutCardInput {
  const CheckoutCardInput({
    required this.cardNumber,
    required this.expiry,
    required this.cvv,
    required this.cardholderName,
    this.saveCardRequested = false,
  });

  final String cardNumber;
  final String expiry;
  final String cvv;
  final String cardholderName;
  final bool saveCardRequested;
}

enum CheckoutValidationError {
  missingCardNumber,
  invalidCardNumberFormat,
  invalidCardNumberLength,
  missingExpiry,
  invalidExpiryFormat,
  invalidExpiryDate,
  expiredCard,
  missingCvv,
  invalidCvvFormat,
  invalidCvvLength,
  missingCardholderName,
  saveCardNotSupported,
}

class CheckoutValidationFailure {
  const CheckoutValidationFailure({
    required this.error,
    required this.message,
  });

  final CheckoutValidationError error;
  final String message;
}

class CheckoutValidationResult {
  const CheckoutValidationResult._({this.failure});

  const CheckoutValidationResult.success() : this._();

  const CheckoutValidationResult.failure(CheckoutValidationFailure failure)
      : this._(failure: failure);

  final CheckoutValidationFailure? failure;

  bool get isValid => failure == null;
}

class CheckoutPaymentController {
  CheckoutPaymentController({DateTime Function()? nowProvider})
      : _nowProvider = nowProvider ?? DateTime.now;

  final DateTime Function() _nowProvider;

  CheckoutValidationResult validateCardInput(CheckoutCardInput input) {
    final cardNumber = input.cardNumber.replaceAll(' ', '');

    if (cardNumber.isEmpty) {
      return const CheckoutValidationResult.failure(
        CheckoutValidationFailure(
          error: CheckoutValidationError.missingCardNumber,
          message: 'Card number is required.',
        ),
      );
    }

    if (!RegExp(r'^\d+$').hasMatch(cardNumber)) {
      return const CheckoutValidationResult.failure(
        CheckoutValidationFailure(
          error: CheckoutValidationError.invalidCardNumberFormat,
          message: 'Card number must contain digits only.',
        ),
      );
    }

    if (cardNumber.length != 16) {
      return const CheckoutValidationResult.failure(
        CheckoutValidationFailure(
          error: CheckoutValidationError.invalidCardNumberLength,
          message: 'Card number must be 16 digits.',
        ),
      );
    }

    final expiry = input.expiry.trim();
    if (expiry.isEmpty) {
      return const CheckoutValidationResult.failure(
        CheckoutValidationFailure(
          error: CheckoutValidationError.missingExpiry,
          message: 'Expiry date is required.',
        ),
      );
    }

    final expiryMatch = RegExp(r'^(\d{2})\/(\d{2})$').firstMatch(expiry);
    if (expiryMatch == null) {
      return const CheckoutValidationResult.failure(
        CheckoutValidationFailure(
          error: CheckoutValidationError.invalidExpiryFormat,
          message: 'Expiry date must use MM/YY format.',
        ),
      );
    }

    final month = int.parse(expiryMatch.group(1)!);
    final year = int.parse(expiryMatch.group(2)!);
    if (month < 1 || month > 12) {
      return const CheckoutValidationResult.failure(
        CheckoutValidationFailure(
          error: CheckoutValidationError.invalidExpiryDate,
          message: 'Expiry month must be between 01 and 12.',
        ),
      );
    }

    final now = _nowProvider();
    final fullYear = 2000 + year;
    final currentMonthStart = DateTime(now.year, now.month);
    final expiryMonthStart = DateTime(fullYear, month);

    if (expiryMonthStart.isBefore(currentMonthStart)) {
      return const CheckoutValidationResult.failure(
        CheckoutValidationFailure(
          error: CheckoutValidationError.expiredCard,
          message: 'Card has expired.',
        ),
      );
    }

    final cvv = input.cvv.trim();
    if (cvv.isEmpty) {
      return const CheckoutValidationResult.failure(
        CheckoutValidationFailure(
          error: CheckoutValidationError.missingCvv,
          message: 'CVV is required.',
        ),
      );
    }

    if (!RegExp(r'^\d+$').hasMatch(cvv)) {
      return const CheckoutValidationResult.failure(
        CheckoutValidationFailure(
          error: CheckoutValidationError.invalidCvvFormat,
          message: 'CVV must contain digits only.',
        ),
      );
    }

    if (cvv.length < 3 || cvv.length > 4) {
      return const CheckoutValidationResult.failure(
        CheckoutValidationFailure(
          error: CheckoutValidationError.invalidCvvLength,
          message: 'CVV must be 3 or 4 digits.',
        ),
      );
    }

    if (input.cardholderName.trim().isEmpty) {
      return const CheckoutValidationResult.failure(
        CheckoutValidationFailure(
          error: CheckoutValidationError.missingCardholderName,
          message: 'Cardholder name is required.',
        ),
      );
    }

    if (input.saveCardRequested) {
      return const CheckoutValidationResult.failure(
        CheckoutValidationFailure(
          error: CheckoutValidationError.saveCardNotSupported,
          message: 'Saving cards is not available yet.',
        ),
      );
    }

    return const CheckoutValidationResult.success();
  }
}
