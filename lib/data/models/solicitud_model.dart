import 'package:equatable/equatable.dart';

enum LoanApplicationStatus {
  draft,
  submitted,
  underReview,
  approved,
  rejected,
  cancelled,
}

class LoanApplicationModel extends Equatable {
  final int id;
  final int userId;
  final double requestedAmount;
  final int requestedTerm;
  final String? purpose;
  final LoanApplicationStatus status;
  final String? analystNotes;
  final DateTime? reviewedAt;
  final int? reviewedBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  const LoanApplicationModel({
    required this.id,
    required this.userId,
    required this.requestedAmount,
    required this.requestedTerm,
    this.purpose,
    required this.status,
    this.analystNotes,
    this.reviewedAt,
    this.reviewedBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory LoanApplicationModel.fromJson(Map<String, dynamic> json) {
    return LoanApplicationModel(
      id: json['id'] as int,
      userId: json['userId'] as int,
      requestedAmount: (json['requestedAmount'] as num).toDouble(),
      requestedTerm: json['requestedTerm'] as int,
      purpose: json['purpose'] as String?,
      status: _parseStatus(json['status'] as String),
      analystNotes: json['analystNotes'] as String?,
      reviewedAt: json['reviewedAt'] != null
          ? DateTime.parse(json['reviewedAt'] as String)
          : null,
      reviewedBy: json['reviewedBy'] as int?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'requestedAmount': requestedAmount,
      'requestedTerm': requestedTerm,
      'purpose': purpose,
      'status': status.name.toUpperCase(),
      'analystNotes': analystNotes,
      'reviewedAt': reviewedAt?.toIso8601String(),
      'reviewedBy': reviewedBy,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  static LoanApplicationStatus _parseStatus(String status) {
    switch (status.toLowerCase()) {
      case 'draft':
        return LoanApplicationStatus.draft;
      case 'submitted':
        return LoanApplicationStatus.submitted;
      case 'under_review':
        return LoanApplicationStatus.underReview;
      case 'approved':
        return LoanApplicationStatus.approved;
      case 'rejected':
        return LoanApplicationStatus.rejected;
      case 'cancelled':
        return LoanApplicationStatus.cancelled;
      default:
        return LoanApplicationStatus.draft;
    }
  }

  String get statusText {
    switch (status) {
      case LoanApplicationStatus.draft:
        return 'Borrador';
      case LoanApplicationStatus.submitted:
        return 'Enviada';
      case LoanApplicationStatus.underReview:
        return 'En Revisión';
      case LoanApplicationStatus.approved:
        return 'Aprobada';
      case LoanApplicationStatus.rejected:
        return 'Rechazada';
      case LoanApplicationStatus.cancelled:
        return 'Cancelada';
    }
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    requestedAmount,
    requestedTerm,
    purpose,
    status,
    analystNotes,
    reviewedAt,
    reviewedBy,
    createdAt,
    updatedAt,
  ];
}

// DTOs
class CreateLoanApplicationDto {
  final double requestedAmount;
  final int requestedTerm;
  final String? purpose;

  const CreateLoanApplicationDto({
    required this.requestedAmount,
    required this.requestedTerm,
    this.purpose,
  });

  Map<String, dynamic> toJson() => {
    'requestedAmount': requestedAmount,
    'requestedTerm': requestedTerm,
    if (purpose != null) 'purpose': purpose,
  };
}

class UpdateLoanApplicationDto {
  final double? requestedAmount;
  final int? requestedTerm;
  final String? purpose;

  const UpdateLoanApplicationDto({
    this.requestedAmount,
    this.requestedTerm,
    this.purpose,
  });

  Map<String, dynamic> toJson() => {
    if (requestedAmount != null) 'requestedAmount': requestedAmount,
    if (requestedTerm != null) 'requestedTerm': requestedTerm,
    if (purpose != null) 'purpose': purpose,
  };
}

class ReviewLoanApplicationDto {
  final String status; // APPROVED, REJECTED, UNDER_REVIEW
  final String? analystNotes;
  final double? approvedAmount;
  final double? interestRate;

  const ReviewLoanApplicationDto({
    required this.status,
    this.analystNotes,
    this.approvedAmount,
    this.interestRate,
  });

  Map<String, dynamic> toJson() => {
    'status': status,
    if (analystNotes != null) 'analystNotes': analystNotes,
    if (approvedAmount != null) 'approvedAmount': approvedAmount,
    if (interestRate != null) 'interestRate': interestRate,
  };
}
