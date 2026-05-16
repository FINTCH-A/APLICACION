import 'package:flutter/material.dart';
import '../models/prestamo_model.dart';
import '../models/solicitud_model.dart';
import '../models/cuota_model.dart';
import '../repositories/prestamo_repository.dart';

class PrestamoProvider extends ChangeNotifier {
  final PrestamoRepository _repository = PrestamoRepository();

  // Estados para Solicitudes
  List<LoanApplicationModel> _loanApplications = [];
  LoanApplicationModel? _currentApplication;
  bool _isLoadingApplications = false;
  String? _applicationsError;

  // Estados para Préstamos
  List<LoanModel> _loans = [];
  LoanModel? _currentLoan;
  bool _isLoadingLoans = false;
  String? _loansError;

  // Estados para Cuotas
  List<InstallmentModel> _installments = [];
  InstallmentModel? _nextDueInstallment;
  bool _isLoadingInstallments = false;
  String? _installmentsError;

  // Getters
  List<LoanApplicationModel> get loanApplications => _loanApplications;
  LoanApplicationModel? get currentApplication => _currentApplication;
  bool get isLoadingApplications => _isLoadingApplications;
  String? get applicationsError => _applicationsError;

  List<LoanModel> get loans => _loans;
  LoanModel? get currentLoan => _currentLoan;
  bool get isLoadingLoans => _isLoadingLoans;
  String? get loansError => _loansError;

  List<InstallmentModel> get installments => _installments;
  InstallmentModel? get nextDueInstallment => _nextDueInstallment;
  bool get isLoadingInstallments => _isLoadingInstallments;
  String? get installmentsError => _installmentsError;

  // ==================== LOAN APPLICATIONS ====================

  Future<void> loadLoanApplications({
    int? page,
    int? limit,
    String? status,
  }) async {
    _isLoadingApplications = true;
    _applicationsError = null;
    notifyListeners();

    try {
      _loanApplications = await _repository.getLoanApplications(
        page: page,
        limit: limit,
        status: status,
      );
      _isLoadingApplications = false;
      notifyListeners();
    } catch (e) {
      _applicationsError = e.toString();
      _isLoadingApplications = false;
      notifyListeners();
    }
  }

  Future<bool> createLoanApplication(CreateLoanApplicationDto dto) async {
    _isLoadingApplications = true;
    _applicationsError = null;
    notifyListeners();

    try {
      _currentApplication = await _repository.createLoanApplication(dto);
      _isLoadingApplications = false;
      notifyListeners();
      await loadLoanApplications(); // Recargar lista
      return true;
    } catch (e) {
      _applicationsError = e.toString();
      _isLoadingApplications = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> submitLoanApplication(int id) async {
    _isLoadingApplications = true;
    _applicationsError = null;
    notifyListeners();

    try {
      _currentApplication = await _repository.submitLoanApplication(id);
      _isLoadingApplications = false;
      notifyListeners();
      await loadLoanApplications();
      return true;
    } catch (e) {
      _applicationsError = e.toString();
      _isLoadingApplications = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> cancelLoanApplication(int id) async {
    _isLoadingApplications = true;
    _applicationsError = null;
    notifyListeners();

    try {
      _currentApplication = await _repository.cancelLoanApplication(id);
      _isLoadingApplications = false;
      notifyListeners();
      await loadLoanApplications();
      return true;
    } catch (e) {
      _applicationsError = e.toString();
      _isLoadingApplications = false;
      notifyListeners();
      return false;
    }
  }

  // ==================== LOANS ====================

  Future<void> loadLoans({int? page, int? limit, String? status}) async {
    _isLoadingLoans = true;
    _loansError = null;
    notifyListeners();

    try {
      _loans = await _repository.getLoans(
        page: page,
        limit: limit,
        status: status,
      );
      _isLoadingLoans = false;
      notifyListeners();
    } catch (e) {
      _loansError = e.toString();
      _isLoadingLoans = false;
      notifyListeners();
    }
  }

  Future<void> loadLoanById(int id) async {
    _isLoadingLoans = true;
    _loansError = null;
    notifyListeners();

    try {
      _currentLoan = await _repository.getLoanById(id);
      _isLoadingLoans = false;
      notifyListeners();
      // Cargar cuotas del préstamo después de obtener el préstamo
      await loadInstallments(id);
    } catch (e) {
      _loansError = e.toString();
      _isLoadingLoans = false;
      notifyListeners();
    }
  }

  // ==================== INSTALLMENTS ====================

  Future<void> loadInstallments(int loanId) async {
    _isLoadingInstallments = true;
    _installmentsError = null;
    notifyListeners();

    try {
      _installments = await _repository.getInstallments(loanId);
      _nextDueInstallment = await _repository.getNextDueInstallment(loanId);
      _isLoadingInstallments = false;
      notifyListeners();
    } catch (e) {
      _installmentsError = e.toString();
      _isLoadingInstallments = false;
      notifyListeners();
    }
  }
}
