import 'dart:math' as math;

const Map<String, int> currencyExponentMap = {
  'USD': 2,
  'EUR': 2,
  'GBP': 2,
  'EGP': 2,
  'JPY': 0,
  'KRW': 0,
  'BHD': 3,
  'KWD': 3,
};

int _currencyExponent(String currency) =>
    currencyExponentMap[currency.toUpperCase()] ?? 2;

int toMinorUnits(double amount, String currency) {
  final exponent = _currencyExponent(currency);
  final factor = math.pow(10, exponent).toDouble();
  return (amount * factor).round();
}

double fromMinorUnits(int minor, String currency) {
  final exponent = _currencyExponent(currency);
  final factor = math.pow(10, exponent).toDouble();
  return minor / factor;
}
