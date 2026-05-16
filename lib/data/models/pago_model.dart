import 'package:equatable/equatable.dart';

enum PaymentStatus { pending, completed, failed, reversed }

class PaymentModel extends Equatable {
  final int id;
  final int userId;
  final int loanId;
  final int? installmentId;
  final int? paymentMethodId;
  final double amount;
  final String currency;
  final PaymentStatus status;
  final DateTime paymentDate;
  final String reference;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const PaymentModel({
    required this.id,
    required this.userId,
    required this.loanId,
    this.installmentId,
    this.paymentMethodId,
    required this.amount,
    required this.currency,
    required this.status,
    required this.paymentDate,
    required this.reference,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'] as int,
      userId: json['userId'] as int,
      loanId: json['loanId'] as int,
      installmentId: json['installmentId'] as int?,
      paymentMethodId: json['paymentMethodId'] as int?,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String,
      status: _parseStatus(json['status'] as String),
      paymentDate: DateTime.parse(json['paymentDate'] as String),
      reference: json['reference'] as String,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  static PaymentStatus _parseStatus(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return PaymentStatus.pending;
      case 'completed':
        return PaymentStatus.completed;
      case 'failed':
        return PaymentStatus.failed;
      case 'reversed':
        return PaymentStatus.reversed;
      default:
        return PaymentStatus.pending;
    }
  }

  String get statusText {
    switch (status) {
      case PaymentStatus.pending:
        return 'Pendiente';
      case PaymentStatus.completed:
        return 'Completado';
      case PaymentStatus.failed:
        return 'Fallido';
      case PaymentStatus.reversed:
        return 'Revertido';
    }
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    loanId,
    installmentId,
    paymentMethodId,
    amount,
    currency,
    status,
    paymentDate,
    reference,
    notes,
    createdAt,
    updatedAt,
  ];
}

// DTOs
class CreatePaymentDto {
  final int loanId;
  final int? installmentId;
  final int? paymentMethodId;
  final double amount;
  final String reference;
  final String? notes;

  const CreatePaymentDto({
    required this.loanId,
    this.installmentId,
    this.paymentMethodId,
    required this.amount,
    required this.reference,
    this.notes,
  });

  Map<String, dynamic> toJson() => {
    'loanId': loanId,
    if (installmentId != null) 'installmentId': installmentId,
    if (paymentMethodId != null) 'paymentMethodId': paymentMethodId,
    'amount': amount,
    'reference': reference,
    if (notes != null) 'notes': notes,
  };
}
