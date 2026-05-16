import 'package:intl/intl.dart';

String formatCurrency(double amount) {
  final formatter = NumberFormat.currency(
    locale: 'es_PE',
    symbol: 'S/',
    decimalDigits: 2,
  );
  return formatter.format(amount);
}

String formatNumber(double number) {
  final formatter = NumberFormat.decimalPattern('es_PE');
  return formatter.format(number);
}

String formatPercentage(double percentage) {
  return '${percentage.toStringAsFixed(1)}%';
}

String formatDate(DateTime date, {String format = 'dd/MM/yyyy'}) {
  return DateFormat(format).format(date);
}

String formatDateTime(DateTime date) {
  return DateFormat('dd/MM/yyyy HH:mm').format(date);
}
