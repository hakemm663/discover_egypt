import 'package:flutter_test/flutter_test.dart';

import 'package:discover_egypt/core/utils/money.dart';

void main() {
  group('toMinorUnits', () {
    test('rounds using exponent for 2-decimal currency', () {
      expect(toMinorUnits(10.005, 'USD'), 1001);
      expect(toMinorUnits(10.004, 'USD'), 1000);
    });

    test('supports zero-decimal currencies', () {
      expect(toMinorUnits(4999.4, 'JPY'), 4999);
      expect(toMinorUnits(4999.5, 'JPY'), 5000);
    });

    test('supports three-decimal currencies', () {
      expect(toMinorUnits(12.3456, 'BHD'), 12346);
    });
  });

  group('fromMinorUnits', () {
    test('converts for different currency exponents', () {
      expect(fromMinorUnits(12345, 'USD'), 123.45);
      expect(fromMinorUnits(12345, 'JPY'), 12345);
      expect(fromMinorUnits(12345, 'KWD'), 12.345);
    });

    test('defaults unknown currencies to 2 decimals', () {
      expect(toMinorUnits(1.234, 'XXX'), 123);
      expect(fromMinorUnits(123, 'XXX'), 1.23);
    });
  });
}
