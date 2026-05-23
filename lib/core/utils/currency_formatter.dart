import 'package:intl/intl.dart';

/// Formatea un monto como "S/ 3,000.00"
/// - Símbolo S/ siempre adelante
/// - Coma como separador de miles
/// - Punto como separador decimal
String formatCurrency(double amount) {
  // Usamos locale en_US para garantizar coma=miles y punto=decimal,
  // luego reemplazamos el símbolo manualmente al inicio.
  final formatter = NumberFormat('#,##0.00', 'en_US');
  return 'S/ ${formatter.format(amount)}';
}

/// Formatea un número con separador de miles (sin símbolo)
/// Ejemplo: 3000 → "3,000"
String formatNumber(double number) {
  final formatter = NumberFormat('#,##0.##', 'en_US');
  return formatter.format(number);
}

/// Formatea un porcentaje con 1 decimal
/// Ejemplo: 12.5 → "12.5%"
String formatPercentage(double percentage) {
  return '${percentage.toStringAsFixed(1)}%';
}

/// Formatea una fecha (por defecto dd/MM/yyyy)
String formatDate(DateTime date, {String format = 'dd/MM/yyyy'}) {
  return DateFormat(format).format(date);
}

/// Formatea fecha y hora como "dd/MM/yyyy HH:mm"
String formatDateTime(DateTime date) {
  return DateFormat('dd/MM/yyyy HH:mm').format(date);
}
