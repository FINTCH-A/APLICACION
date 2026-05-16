import '../constants/env.dart';

class ApiEndpoints {
  // Base URL desde .env
  static String get baseUrl => Env.apiUrl;

  // Timeouts
  static Duration get connectionTimeout =>
      Duration(milliseconds: Env.apiTimeout);
  static Duration get receiveTimeout => Duration(milliseconds: Env.apiTimeout);

  // ==================== AUTH ====================
  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String refresh = '/auth/refresh';
  static const String logout = '/auth/logout';
  static const String logoutAll = '/auth/logout-all';
  static const String me = '/auth/me';
  static const String changePassword = '/auth/change-password';

  // ==================== USERS ====================
  static const String users = '/users';
  static const String usersStats = '/users/stats';
  static const String userStatus = '/users/:id/status';

  // ==================== ADDRESS ====================
  static const String address = '/users/:userId/address';

  // ==================== KYC ====================
  static const String kyc = '/users/:userId/kyc';
  static const String kycUpload = '/users/:userId/kyc/upload';
  static const String kycVerify = '/users/:userId/kyc/verify';

  // ==================== FINANCIAL INFO ====================
  static const String financialInfo = '/users/:userId/financial-info';

  // ==================== FAMILY INFO ====================
  static const String familyInfo = '/users/:userId/family-info';

  // ==================== PAYMENT METHODS ====================
  static const String paymentMethods = '/users/:userId/payment-methods';

  // ==================== LOAN APPLICATIONS ====================
  static const String loanApplications = '/loan-applications';
  static const String loanApplicationSubmit = '/loan-applications/:id/submit';
  static const String loanApplicationReview = '/loan-applications/:id/review';
  static const String loanApplicationCancel = '/loan-applications/:id/cancel';

  // ==================== LOANS ====================
  static const String loans = '/loans';
  static const String loanDisburse = '/loans/:id/disburse';

  // ==================== INSTALLMENTS ====================
  static const String installments = '/loans/:loanId/installments';
  static const String nextDueInstallment =
      '/loans/:loanId/installments/next-due';

  // ==================== PAYMENTS ====================
  static const String payments = '/payments';
  static const String paymentReverse = '/payments/:id/reverse';

  // ==================== TRANSACTIONS ====================
  static const String transactions = '/transactions';
  static const String transactionByPayment = '/transactions/payment/:paymentId';

  // ==================== CREDIT SCORE ====================
  static const String creditScore = '/users/:userId/credit-score';
  static const String creditScoreHistory =
      '/users/:userId/credit-score/history';

  // ==================== RISK ASSESSMENT ====================
  static const String riskAssessment = '/users/:userId/risk-assessment';
  static const String riskAssessmentHistory =
      '/users/:userId/risk-assessment/history';

  // ==================== DASHBOARD ====================
  static const String dashboardStats = '/dashboard/stats';
  static const String dashboardRecentActivity = '/dashboard/recent-activity';
  static const String dashboardAlerts = '/dashboard/alerts';

  // ==================== NOTIFICATIONS ====================
  static const String notifications = '/notifications';
  static const String notificationsSystem = '/notifications/system';
  static const String notificationRead = '/notifications/:id/read';
  static const String notificationsReadAll = '/notifications/read-all';

  // ==================== LEDGER ====================
  static const String ledger = '/ledger';
  static const String ledgerBalance = '/ledger/loans/:loanId/balance';

  // ==================== WEBHOOKS ====================
  static const String webhooks = '/webhooks/receive';
  static const String webhooksProcessPending = '/webhooks/process-pending';

  // Helper para reemplazar parámetros
  static String replaceParam(String url, String param, String value) {
    return url.replaceAll(':$param', value);
  }

  static String replaceMultipleParams(String url, Map<String, String> params) {
    var result = url;
    params.forEach((key, value) {
      result = result.replaceAll(':$key', value);
    });
    return result;
  }
}
