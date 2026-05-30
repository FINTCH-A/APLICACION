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

  // Nuevos campos para la solicitud completa
  final String? country;
  final String? department;
  final String? city;
  final String? district;
  final String? streetAddress;
  final String? postalCode;
  final String? employmentStatus;
  final String? employerName;
  final double? monthlyIncome;
  final double? monthlyExpenses;
  final int? numberOfDependents;
  final double? otherIncomeSources;
  final String? maritalStatus;
  final String? housingType;
  final int? numberOfChildren;
  final String? paymentType;
  final String? paymentProvider;
  final String? accountNumber;
  final String? accountHolder;

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
    this.country,
    this.department,
    this.city,
    this.district,
    this.streetAddress,
    this.postalCode,
    this.employmentStatus,
    this.employerName,
    this.monthlyIncome,
    this.monthlyExpenses,
    this.numberOfDependents,
    this.otherIncomeSources,
    this.maritalStatus,
    this.housingType,
    this.numberOfChildren,
    this.paymentType,
    this.paymentProvider,
    this.accountNumber,
    this.accountHolder,
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
      // Nuevos campos
      country: json['country'] as String?,
      department: json['department'] as String?,
      city: json['city'] as String?,
      district: json['district'] as String?,
      streetAddress: json['streetAddress'] as String?,
      postalCode: json['postalCode'] as String?,
      employmentStatus: json['employmentStatus'] as String?,
      employerName: json['employerName'] as String?,
      monthlyIncome: (json['monthlyIncome'] as num?)?.toDouble(),
      monthlyExpenses: (json['monthlyExpenses'] as num?)?.toDouble(),
      numberOfDependents: json['numberOfDependents'] as int?,
      otherIncomeSources: (json['otherIncomeSources'] as num?)?.toDouble(),
      maritalStatus: json['maritalStatus'] as String?,
      housingType: json['housingType'] as String?,
      numberOfChildren: json['numberOfChildren'] as int?,
      paymentType: json['paymentType'] as String?,
      paymentProvider: json['paymentProvider'] as String?,
      accountNumber: json['accountNumber'] as String?,
      accountHolder: json['accountHolder'] as String?,
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
      'country': country,
      'department': department,
      'city': city,
      'district': district,
      'streetAddress': streetAddress,
      'postalCode': postalCode,
      'employmentStatus': employmentStatus,
      'employerName': employerName,
      'monthlyIncome': monthlyIncome,
      'monthlyExpenses': monthlyExpenses,
      'numberOfDependents': numberOfDependents,
      'otherIncomeSources': otherIncomeSources,
      'maritalStatus': maritalStatus,
      'housingType': housingType,
      'numberOfChildren': numberOfChildren,
      'paymentType': paymentType,
      'paymentProvider': paymentProvider,
      'accountNumber': accountNumber,
      'accountHolder': accountHolder,
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
    country,
    department,
    city,
    district,
    streetAddress,
    postalCode,
    employmentStatus,
    employerName,
    monthlyIncome,
    monthlyExpenses,
    numberOfDependents,
    otherIncomeSources,
    maritalStatus,
    housingType,
    numberOfChildren,
    paymentType,
    paymentProvider,
    accountNumber,
    accountHolder,
  ];
}

// ==================== DTO COMPLETO PARA CREAR SOLICITUD ====================

class CreateLoanApplicationDto {
  final double requestedAmount;
  final int requestedTerm;
  final String? purpose;

  // Datos de dirección (Step2)
  final String? country;
  final String? department;
  final String? city;
  final String? district;
  final String? streetAddress;
  final String? postalCode;

  // Datos laborales (Step3)
  final String? employmentStatus;
  final String? employerName;
  final double? monthlyIncome;
  final double? monthlyExpenses;
  final int? numberOfDependents;
  final double? otherIncomeSources;

  // Datos personales (Step4)
  final String? maritalStatus;
  final String? housingType;
  final int? numberOfChildren;

  // Datos de pago (Step5)
  final String? paymentType;
  final String? paymentProvider;
  final String? accountNumber;
  final String? accountHolder;

  const CreateLoanApplicationDto({
    required this.requestedAmount,
    required this.requestedTerm,
    this.purpose,
    // Step2
    this.country,
    this.department,
    this.city,
    this.district,
    this.streetAddress,
    this.postalCode,
    // Step3
    this.employmentStatus,
    this.employerName,
    this.monthlyIncome,
    this.monthlyExpenses,
    this.numberOfDependents,
    this.otherIncomeSources,
    // Step4
    this.maritalStatus,
    this.housingType,
    this.numberOfChildren,
    // Step5
    this.paymentType,
    this.paymentProvider,
    this.accountNumber,
    this.accountHolder,
  });

  Map<String, dynamic> toJson() {
    return {
      'requestedAmount': requestedAmount,
      'requestedTerm': requestedTerm,
      if (purpose != null) 'purpose': purpose,
      // Step2
      if (country != null) 'country': country,
      if (department != null) 'department': department,
      if (city != null) 'city': city,
      if (district != null) 'district': district,
      if (streetAddress != null) 'streetAddress': streetAddress,
      if (postalCode != null) 'postalCode': postalCode,
      // Step3
      if (employmentStatus != null) 'employmentStatus': employmentStatus,
      if (employerName != null) 'employerName': employerName,
      if (monthlyIncome != null) 'monthlyIncome': monthlyIncome,
      if (monthlyExpenses != null) 'monthlyExpenses': monthlyExpenses,
      if (numberOfDependents != null) 'numberOfDependents': numberOfDependents,
      if (otherIncomeSources != null) 'otherIncomeSources': otherIncomeSources,
      // Step4
      if (maritalStatus != null) 'maritalStatus': maritalStatus,
      if (housingType != null) 'housingType': housingType,
      if (numberOfChildren != null) 'numberOfChildren': numberOfChildren,
      // Step5
      if (paymentType != null) 'paymentType': paymentType,
      if (paymentProvider != null) 'paymentProvider': paymentProvider,
      if (accountNumber != null) 'accountNumber': accountNumber,
      if (accountHolder != null) 'accountHolder': accountHolder,
    };
  }
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
