import 'package:equatable/equatable.dart';

enum InstallmentStatus { pending, paid, overdue, partiallyPaid, waived }

class InstallmentModel extends Equatable {
  final int id;
  final int loanId;
  final int installmentNumber;
  final double principalAmount;
  final double interestAmount;
  final double totalAmount;
  final double paidAmount;
  final double pendingAmount;
  final String currency;
  final DateTime dueDate;
  final DateTime? paidAt;
  final InstallmentStatus status;
  final double? penaltyFee;
  final int daysOverdue;
  final bool isOverdue;
  final DateTime createdAt;
  final DateTime updatedAt;

  const InstallmentModel({
    required this.id,
    required this.loanId,
    required this.installmentNumber,
    required this.principalAmount,
    required this.interestAmount,
    required this.totalAmount,
    required this.paidAmount,
    required this.pendingAmount,
    required this.currency,
    required this.dueDate,
    this.paidAt,
    required this.status,
    this.penaltyFee,
    required this.daysOverdue,
    required this.isOverdue,
    required this.createdAt,
    required this.updatedAt,
  });

  factory InstallmentModel.fromJson(Map<String, dynamic> json) {
    return InstallmentModel(
      id: json['id'] as int,
      loanId: json['loanId'] as int,
      installmentNumber: json['installmentNumber'] as int,
      principalAmount: (json['principalAmount'] as num).toDouble(),
      interestAmount: (json['interestAmount'] as num).toDouble(),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      paidAmount: (json['paidAmount'] as num).toDouble(),
      pendingAmount: (json['pendingAmount'] as num).toDouble(),
      currency: json['currency'] as String,
      dueDate: DateTime.parse(json['dueDate'] as String),
      paidAt: json['paidAt'] != null
          ? DateTime.parse(json['paidAt'] as String)
          : null,
      status: _parseStatus(json['status'] as String),
      penaltyFee: json['penaltyFee'] != null
          ? (json['penaltyFee'] as num).toDouble()
          : null,
      daysOverdue: json['daysOverdue'] as int,
      isOverdue: json['isOverdue'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  static InstallmentStatus _parseStatus(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return InstallmentStatus.pending;
      case 'paid':
        return InstallmentStatus.paid;
      case 'overdue':
        return InstallmentStatus.overdue;
      case 'partially_paid':
        return InstallmentStatus.partiallyPaid;
      case 'waived':
        return InstallmentStatus.waived;
      default:
        return InstallmentStatus.pending;
    }
  }

  String get statusText {
    switch (status) {
      case InstallmentStatus.pending:
        return 'Pendiente';
      case InstallmentStatus.paid:
        return 'Pagada';
      case InstallmentStatus.overdue:
        return 'Vencida';
      case InstallmentStatus.partiallyPaid:
        return 'Parcial';
      case InstallmentStatus.waived:
        return 'Condonada';
    }
  }

  double get progressPercentage =>
      totalAmount > 0 ? (paidAmount / totalAmount) * 100 : 0;

  @override
  List<Object?> get props => [
    id,
    loanId,
    installmentNumber,
    principalAmount,
    interestAmount,
    totalAmount,
    paidAmount,
    pendingAmount,
    currency,
    dueDate,
    paidAt,
    status,
    penaltyFee,
    daysOverdue,
    isOverdue,
    createdAt,
    updatedAt,
  ];
}
