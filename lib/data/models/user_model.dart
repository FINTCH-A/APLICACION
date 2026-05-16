import 'package:equatable/equatable.dart';

enum UserRole { customer, analyst, admin }

enum UserStatus { active, inactive, suspended, pendingVerification }

class UserModel extends Equatable {
  final int id;
  final String firstName;
  final String lastName;
  final String dni;
  final String email;
  final String phone;
  final DateTime dateOfBirth;
  final UserRole role;
  final UserStatus status;
  final bool emailVerified;
  final bool phoneVerified;
  final DateTime? lastLogin;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.dni,
    required this.email,
    required this.phone,
    required this.dateOfBirth,
    required this.role,
    required this.status,
    required this.emailVerified,
    required this.phoneVerified,
    this.lastLogin,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int? ?? 0,
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      dni: json['dni'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.parse(json['dateOfBirth'] as String)
          : DateTime.now(),
      role: _parseRole(json['role'] as String?),
      status: _parseStatus(json['status'] as String?),
      emailVerified: json['emailVerified'] as bool? ?? false,
      phoneVerified: json['phoneVerified'] as bool? ?? false,
      lastLogin: json['lastLogin'] != null
          ? DateTime.parse(json['lastLogin'] as String)
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'dni': dni,
      'email': email,
      'phone': phone,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'role': role.name.toUpperCase(),
      'status': status.name.toUpperCase(),
      'emailVerified': emailVerified,
      'phoneVerified': phoneVerified,
      'lastLogin': lastLogin?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  static UserRole _parseRole(String? role) {
    if (role == null) return UserRole.customer;
    switch (role.toLowerCase()) {
      case 'customer':
        return UserRole.customer;
      case 'analyst':
        return UserRole.analyst;
      case 'admin':
        return UserRole.admin;
      default:
        return UserRole.customer;
    }
  }

  static UserStatus _parseStatus(String? status) {
    if (status == null) return UserStatus.active;
    switch (status.toLowerCase()) {
      case 'active':
        return UserStatus.active;
      case 'inactive':
        return UserStatus.inactive;
      case 'suspended':
        return UserStatus.suspended;
      case 'pending_verification':
        return UserStatus.pendingVerification;
      default:
        return UserStatus.active;
    }
  }

  String get fullName => '$firstName $lastName';

  @override
  List<Object?> get props => [
    id,
    firstName,
    lastName,
    dni,
    email,
    phone,
    dateOfBirth,
    role,
    status,
    emailVerified,
    phoneVerified,
    lastLogin,
    createdAt,
    updatedAt,
  ];
}

// DTOs de autenticación
class AuthTokensDto {
  final String accessToken;
  final String refreshToken;
  final String tokenType;
  final String expiresIn;

  const AuthTokensDto({
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
    required this.expiresIn,
  });

  factory AuthTokensDto.fromJson(Map<String, dynamic> json) {
    // Manejar estructura anidada { data: { data: { ... } } }
    dynamic data = json;

    // Extraer si hay estructura anidada
    if (data['data'] != null && data['data'] is Map) {
      data = data['data'] as Map<String, dynamic>;
    }
    if (data['data'] != null && data['data'] is Map) {
      data = data['data'] as Map<String, dynamic>;
    }

    return AuthTokensDto(
      accessToken: data['accessToken'] as String? ?? '',
      refreshToken: data['refreshToken'] as String? ?? '',
      tokenType: data['tokenType'] as String? ?? 'Bearer',
      expiresIn: data['expiresIn'] as String? ?? '15m',
    );
  }
}

class LoginDto {
  final String email;
  final String password;

  const LoginDto({required this.email, required this.password});

  Map<String, dynamic> toJson() => {'email': email, 'password': password};
}

class RegisterDto {
  final String firstName;
  final String lastName;
  final String dni;
  final String email;
  final String phone;
  final String dateOfBirth;
  final String password;

  const RegisterDto({
    required this.firstName,
    required this.lastName,
    required this.dni,
    required this.email,
    required this.phone,
    required this.dateOfBirth,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
    'firstName': firstName,
    'lastName': lastName,
    'dni': dni,
    'email': email,
    'phone': phone,
    'dateOfBirth': dateOfBirth,
    'password': password,
  };
}

class RefreshTokenDto {
  final String refreshToken;

  const RefreshTokenDto({required this.refreshToken});

  Map<String, dynamic> toJson() => {'refreshToken': refreshToken};
}

class ChangePasswordDto {
  final String currentPassword;
  final String newPassword;

  const ChangePasswordDto({
    required this.currentPassword,
    required this.newPassword,
  });

  Map<String, dynamic> toJson() => {
    'currentPassword': currentPassword,
    'newPassword': newPassword,
  };
}
