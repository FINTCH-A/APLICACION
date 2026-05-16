import 'package:equatable/equatable.dart';

enum NotificationType {
  loanApproved,
  loanRejected,
  paymentDue,
  paymentReceived,
  paymentOverdue,
  accountUpdate,
  systemAlert,
}

class NotificationModel extends Equatable {
  final int id;
  final int userId;
  final NotificationType type;
  final String title;
  final String message;
  final bool isRead;
  final DateTime? readAt;
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;

  const NotificationModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.message,
    required this.isRead,
    this.readAt,
    this.metadata,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as int,
      userId: json['userId'] as int,
      type: _parseType(json['type'] as String),
      title: json['title'] as String,
      message: json['message'] as String,
      isRead: json['isRead'] as bool,
      readAt: json['readAt'] != null
          ? DateTime.parse(json['readAt'] as String)
          : null,
      metadata: json['metadata'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  static NotificationType _parseType(String type) {
    switch (type.toLowerCase()) {
      case 'loan_approved':
        return NotificationType.loanApproved;
      case 'loan_rejected':
        return NotificationType.loanRejected;
      case 'payment_due':
        return NotificationType.paymentDue;
      case 'payment_received':
        return NotificationType.paymentReceived;
      case 'payment_overdue':
        return NotificationType.paymentOverdue;
      case 'account_update':
        return NotificationType.accountUpdate;
      case 'system_alert':
        return NotificationType.systemAlert;
      default:
        return NotificationType.systemAlert;
    }
  }

  String get typeIcon {
    switch (type) {
      case NotificationType.loanApproved:
        return '✅';
      case NotificationType.loanRejected:
        return '❌';
      case NotificationType.paymentDue:
        return '⚠️';
      case NotificationType.paymentReceived:
        return '💰';
      case NotificationType.paymentOverdue:
        return '🔴';
      case NotificationType.accountUpdate:
        return '👤';
      case NotificationType.systemAlert:
        return '📢';
    }
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    type,
    title,
    message,
    isRead,
    readAt,
    metadata,
    createdAt,
  ];
}
