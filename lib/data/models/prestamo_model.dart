import 'package:equatable/equatable.dart';

enum LoanStatus {
  pending,
  approved,
  rejected,
  active,
  paid,
  defaulted,
  cancelled,
}

enum InterestType { fixed, variable }

enum AmortizationType { french, german }

class LoanModel extends Equatable {
  final int id;
  final int userId;
  final int loanApplicationId;
  final String loanCode;
  final double requestedAmount;
  final double approvedAmount;
  final double interestRate;
  final InterestType interestType;
  final AmortizationType amortization;
  final double totalAmount;
  final int termMonths;
  final String currency;
  final DateTime? disbursedAt;
  final DateTime dueDate;
  final LoanStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  const LoanModel({
    required this.id,
    required this.userId,
    required this.loanApplicationId,
    required this.loanCode,
    required this.requestedAmount,
    required this.approvedAmount,
    required this.interestRate,
    required this.interestType,
    required this.amortization,
    required this.totalAmount,
    required this.termMonths,
    required this.currency,
    this.disbursedAt,
    required this.dueDate,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory LoanModel.fromJson(Map<String, dynamic> json) {
    return LoanModel(
      id: json['id'] as int,
      userId: json['userId'] as int,
      loanApplicationId: json['loanApplicationId'] as int,
      loanCode: json['loanCode'] as String,
      requestedAmount: (json['requestedAmount'] as num).toDouble(),
      approvedAmount: (json['approvedAmount'] as num).toDouble(),
      interestRate: (json['interestRate'] as num).toDouble(),
      interestType: _parseInterestType(json['interestType'] as String),
      amortization: _parseAmortization(json['amortization'] as String),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      termMonths: json['termMonths'] as int,
      currency: json['currency'] as String,
      disbursedAt: json['disbursedAt'] != null
          ? DateTime.parse(json['disbursedAt'] as String)
          : null,
      dueDate: DateTime.parse(json['dueDate'] as String),
      status: _parseLoanStatus(json['status'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  static InterestType _parseInterestType(String type) {
    return type.toLowerCase() == 'fixed'
        ? InterestType.fixed
        : InterestType.variable;
  }

  static AmortizationType _parseAmortization(String type) {
    return type.toLowerCase() == 'french'
        ? AmortizationType.french
        : AmortizationType.german;
  }

  static LoanStatus _parseLoanStatus(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return LoanStatus.pending;
      case 'approved':
        return LoanStatus.approved;
      case 'rejected':
        return LoanStatus.rejected;
      case 'active':
        return LoanStatus.active;
      case 'paid':
        return LoanStatus.paid;
      case 'defaulted':
        return LoanStatus.defaulted;
      case 'cancelled':
        return LoanStatus.cancelled;
      default:
        return LoanStatus.pending;
    }
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    loanApplicationId,
    loanCode,
    requestedAmount,
    approvedAmount,
    interestRate,
    interestType,
    amortization,
    totalAmount,
    termMonths,
    currency,
    disbursedAt,
    dueDate,
    status,
    createdAt,
    updatedAt,
  ];
}
