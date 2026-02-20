import 'package:intl/intl.dart';

String formatMoney(double amount, {String currency = 'USD'}) {
  return NumberFormat.simpleCurrency(name: currency.toUpperCase())
      .format(amount);
}
