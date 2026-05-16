import 'package:flutter/material.dart';
import '../models/pago_model.dart';
import '../repositories/pago_repository.dart';

class PagoProvider extends ChangeNotifier {
  final PagoRepository _repository = PagoRepository();

  List<PaymentModel> _payments = [];
  PaymentModel? _currentPayment;
  bool _isLoading = false;
  String? _error;

  List<PaymentModel> get payments => _payments;
  PaymentModel? get currentPayment => _currentPayment;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadPayments({
    int? page,
    int? limit,
    int? loanId,
    String? status,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _payments = await _repository.getPayments(
        page: page,
        limit: limit,
        loanId: loanId,
        status: status,
      );
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadPaymentById(int id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _currentPayment = await _repository.getPaymentById(id);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createPayment(CreatePaymentDto dto) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _currentPayment = await _repository.createPayment(dto);
      _isLoading = false;
      notifyListeners();
      // Recargar lista de pagos
      await loadPayments();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> reversePayment(int id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _currentPayment = await _repository.reversePayment(id);
      _isLoading = false;
      notifyListeners();
      await loadPayments();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void clearCurrentPayment() {
    _currentPayment = null;
    notifyListeners();
  }
}
