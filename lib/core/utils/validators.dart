class Validators {
  // ==================== REQUIRED ====================

  static String? required(String? value, {String fieldName = 'Campo'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName es requerido';
    }
    return null;
  }

  // ==================== EMAIL ====================

  static String? email(String? value) {
    if (value == null || value.isEmpty) return null;

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value)) {
      return 'Ingrese un correo electrónico válido';
    }
    return null;
  }

  // ==================== DNI ====================

  static String? dni(String? value) {
    if (value == null || value.isEmpty) return null;

    final dniRegex = RegExp(r'^\d{8}$');
    if (!dniRegex.hasMatch(value)) {
      return 'DNI debe tener 8 dígitos';
    }
    return null;
  }

  // ==================== PHONE ====================

  static String? phone(String? value) {
    if (value == null || value.isEmpty) return null;

    final phoneRegex = RegExp(r'^\d{9}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Teléfono debe tener 9 dígitos';
    }
    return null;
  }

  // ==================== PASSWORD ====================

  static String? password(String? value) {
    if (value == null || value.isEmpty) return null;

    if (value.length < 8) {
      return 'La contraseña debe tener al menos 8 caracteres';
    }
    return null;
  }

  static String? passwordStrong(String? value) {
    if (value == null || value.isEmpty) return null;

    if (value.length < 8) {
      return 'La contraseña debe tener al menos 8 caracteres';
    }

    final hasUppercase = value.contains(RegExp(r'[A-Z]'));
    final hasLowercase = value.contains(RegExp(r'[a-z]'));
    final hasDigits = value.contains(RegExp(r'\d'));
    final hasSpecialChars = value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    if (!hasUppercase) {
      return 'Debe incluir al menos una mayúscula';
    }
    if (!hasLowercase) {
      return 'Debe incluir al menos una minúscula';
    }
    if (!hasDigits) {
      return 'Debe incluir al menos un número';
    }
    if (!hasSpecialChars) {
      return 'Debe incluir al menos un carácter especial';
    }

    return null;
  }

  static String? passwordMatch(String? value, String password) {
    if (value == null || value.isEmpty) return null;

    if (value != password) {
      return 'Las contraseñas no coinciden';
    }
    return null;
  }

  // ==================== NUMBERS ====================

  static String? number(String? value) {
    if (value == null || value.isEmpty) return null;

    if (!RegExp(r'^\d+$').hasMatch(value)) {
      return 'Ingrese solo números';
    }
    return null;
  }

  static String? decimal(String? value) {
    if (value == null || value.isEmpty) return null;

    if (!RegExp(r'^\d+(\.\d{1,2})?$').hasMatch(value)) {
      return 'Ingrese un monto válido (ej: 100.00)';
    }
    return null;
  }

  static String? min(double value, double min, {String fieldName = 'Valor'}) {
    if (value < min) {
      return '$fieldName debe ser mayor o igual a $min';
    }
    return null;
  }

  static String? max(double value, double max, {String fieldName = 'Valor'}) {
    if (value > max) {
      return '$fieldName debe ser menor o igual a $max';
    }
    return null;
  }

  static String? range(
    double value,
    double min,
    double max, {
    String fieldName = 'Valor',
  }) {
    if (value < min) {
      return '$fieldName debe ser mayor o igual a $min';
    }
    if (value > max) {
      return '$fieldName debe ser menor o igual a $max';
    }
    return null;
  }

  static String? positive(double value, {String fieldName = 'Valor'}) {
    if (value <= 0) {
      return '$fieldName debe ser mayor a 0';
    }
    return null;
  }

  // ==================== DATES ====================

  static String? date(String? value) {
    if (value == null || value.isEmpty) return null;

    final dateRegex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
    if (!dateRegex.hasMatch(value)) {
      return 'Ingrese una fecha válida (AAAA-MM-DD)';
    }
    return null;
  }

  static String? minDate(
    DateTime date,
    DateTime minDate, {
    String fieldName = 'Fecha',
  }) {
    if (date.isBefore(minDate)) {
      return '$fieldName debe ser posterior a ${_formatDate(minDate)}';
    }
    return null;
  }

  static String? maxDate(
    DateTime date,
    DateTime maxDate, {
    String fieldName = 'Fecha',
  }) {
    if (date.isAfter(maxDate)) {
      return '$fieldName debe ser anterior a ${_formatDate(maxDate)}';
    }
    return null;
  }

  static String? age(
    DateTime birthDate,
    int minAge, {
    String fieldName = 'Edad',
  }) {
    final today = DateTime.now();
    var age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }

    if (age < minAge) {
      return 'Debes tener al menos $minAge años';
    }
    return null;
  }

  // ==================== LENGTHS ====================

  static String? minLength(
    String? value,
    int minLength, {
    String fieldName = 'Campo',
  }) {
    if (value == null || value.isEmpty) return null;

    if (value.length < minLength) {
      return '$fieldName debe tener al menos $minLength caracteres';
    }
    return null;
  }

  static String? maxLength(
    String? value,
    int maxLength, {
    String fieldName = 'Campo',
  }) {
    if (value == null || value.isEmpty) return null;

    if (value.length > maxLength) {
      return '$fieldName no debe exceder los $maxLength caracteres';
    }
    return null;
  }

  static String? exactLength(
    String? value,
    int length, {
    String fieldName = 'Campo',
  }) {
    if (value == null || value.isEmpty) return null;

    if (value.length != length) {
      return '$fieldName debe tener exactamente $length caracteres';
    }
    return null;
  }

  // ==================== PATTERNS ====================

  static String? pattern(
    String? value,
    RegExp pattern, {
    String fieldName = 'Campo',
  }) {
    if (value == null || value.isEmpty) return null;

    if (!pattern.hasMatch(value)) {
      return '$fieldName no tiene un formato válido';
    }
    return null;
  }

  static String? url(String? value) {
    if (value == null || value.isEmpty) return null;

    final urlRegex = RegExp(
      r'^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$',
      caseSensitive: false,
    );
    if (!urlRegex.hasMatch(value)) {
      return 'Ingrese una URL válida';
    }
    return null;
  }

  static String? alphanumeric(String? value, {String fieldName = 'Campo'}) {
    if (value == null || value.isEmpty) return null;

    if (!RegExp(r'^[a-zA-Z0-9\s]+$').hasMatch(value)) {
      return '$fieldName solo puede contener letras, números y espacios';
    }
    return null;
  }

  static String? letters(String? value, {String fieldName = 'Campo'}) {
    if (value == null || value.isEmpty) return null;

    if (!RegExp(r'^[a-zA-ZáéíóúñÑ\s]+$').hasMatch(value)) {
      return '$fieldName solo puede contener letras y espacios';
    }
    return null;
  }

  // ==================== AMOUNTS ====================

  static String? loanAmount(String? value) {
    if (value == null || value.isEmpty) return null;

    final amount = double.tryParse(value);
    if (amount == null) {
      return 'Ingrese un monto válido';
    }
    if (amount < 100) {
      return 'El monto mínimo es S/ 100';
    }
    if (amount > 50000) {
      return 'El monto máximo es S/ 50,000';
    }
    return null;
  }

  static String? loanTerm(String? value) {
    if (value == null || value.isEmpty) return null;

    final term = int.tryParse(value);
    if (term == null) {
      return 'Ingrese un plazo válido';
    }
    if (term < 3) {
      return 'El plazo mínimo es 3 meses';
    }
    if (term > 60) {
      return 'El plazo máximo es 60 meses';
    }
    return null;
  }

  // ==================== HELPERS ====================

  static String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  // Validación combinada
  static String? combine(List<String? Function()> validators) {
    for (final validator in validators) {
      final error = validator();
      if (error != null) return error;
    }
    return null;
  }
}

// Extension para facilitar el uso
extension StringValidation on String {
  bool get isValidEmail => Validators.email(this) == null;
  bool get isValidDni => Validators.dni(this) == null;
  bool get isValidPhone => Validators.phone(this) == null;
  bool get isStrongPassword => Validators.passwordStrong(this) == null;
  bool get isNumeric => Validators.number(this) == null;
  bool get isDecimal => Validators.decimal(this) == null;
  bool get isAlphanumeric => Validators.alphanumeric(this) == null;
  bool get isLetters => Validators.letters(this) == null;
  bool get isValidUrl => Validators.url(this) == null;
}
