import 'package:flutter/material.dart';
import '../models/solicitud_model.dart';
import '../repositories/solicitud_repository.dart';

class SolicitudProvider extends ChangeNotifier {
  final SolicitudRepository _repository = SolicitudRepository();

  // Estados
  List<LoanApplicationModel> _solicitudes = [];
  LoanApplicationModel? _currentSolicitud;
  bool _isLoading = false;
  bool _isSubmitting = false;
  String? _error;

  // Paginación
  int _currentPage = 1;
  int _totalPages = 1;
  bool _hasMore = true;

  // Filtros
  String? _statusFilter;
  String? _searchQuery;

  // Getters
  List<LoanApplicationModel> get solicitudes => _solicitudes;
  LoanApplicationModel? get currentSolicitud => _currentSolicitud;
  bool get isLoading => _isLoading;
  bool get isSubmitting => _isSubmitting;
  String? get error => _error;

  // Paginación
  int get currentPage => _currentPage;
  int get totalPages => _totalPages;
  bool get hasMore => _hasMore;

  // Filtros
  String? get statusFilter => _statusFilter;
  String? get searchQuery => _searchQuery;

  // Helper
  bool get hasSolicitudes => _solicitudes.isNotEmpty;

  // ==================== LOAD SOLICITUDES ====================

  Future<void> loadSolicitudes({
    bool refresh = false,
    String? status,
    String? search,
  }) async {
    if (refresh) {
      _currentPage = 1;
      _solicitudes = [];
      _hasMore = true;
    }

    if (!_hasMore && !refresh) return;

    _setLoading(true);
    _clearError();

    try {
      final response = await _repository.getLoanApplications(
        page: _currentPage,
        limit: 20,
        status: status ?? _statusFilter,
        search: search ?? _searchQuery,
      );

      if (refresh) {
        _solicitudes = response;
      } else {
        _solicitudes.addAll(response);
      }

      // Actualizar paginación
      _hasMore = response.length >= 20;
      if (_hasMore) _currentPage++;

      _setLoading(false);
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
    }
  }

  Future<void> refreshSolicitudes() async {
    await loadSolicitudes(refresh: true);
  }

  Future<void> loadMoreSolicitudes() async {
    if (!_isLoading && _hasMore) {
      await loadSolicitudes();
    }
  }

  // ==================== FILTERS ====================

  void setStatusFilter(String? status) {
    _statusFilter = status;
    refreshSolicitudes();
  }

  void setSearchQuery(String? query) {
    _searchQuery = query;
    refreshSolicitudes();
  }

  void clearFilters() {
    _statusFilter = null;
    _searchQuery = null;
    refreshSolicitudes();
  }

  // ==================== SINGLE SOLICITUD ====================

  Future<void> loadSolicitudById(int id) async {
    _setLoading(true);
    _clearError();

    try {
      _currentSolicitud = await _repository.getLoanApplicationById(id);
      _setLoading(false);
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
    }
  }

  Future<bool> createSolicitud(CreateLoanApplicationDto dto) async {
    _setSubmitting(true);
    _clearError();

    try {
      _currentSolicitud = await _repository.createLoanApplication(dto);
      _setSubmitting(false);
      await refreshSolicitudes();
      return true;
    } catch (e) {
      _error = e.toString();
      _setSubmitting(false);
      return false;
    }
  }

  Future<bool> updateSolicitud(int id, UpdateLoanApplicationDto dto) async {
    _setSubmitting(true);
    _clearError();

    try {
      _currentSolicitud = await _repository.updateLoanApplication(id, dto);
      _setSubmitting(false);
      await refreshSolicitudes();
      return true;
    } catch (e) {
      _error = e.toString();
      _setSubmitting(false);
      return false;
    }
  }

  Future<bool> submitSolicitud(int id) async {
    _setSubmitting(true);
    _clearError();

    try {
      _currentSolicitud = await _repository.submitLoanApplication(id);
      _setSubmitting(false);
      await refreshSolicitudes();
      return true;
    } catch (e) {
      _error = e.toString();
      _setSubmitting(false);
      return false;
    }
  }

  Future<bool> cancelSolicitud(int id) async {
    _setSubmitting(true);
    _clearError();

    try {
      _currentSolicitud = await _repository.cancelLoanApplication(id);
      _setSubmitting(false);
      await refreshSolicitudes();
      return true;
    } catch (e) {
      _error = e.toString();
      _setSubmitting(false);
      return false;
    }
  }

  // ==================== STATS ====================

  int countByStatus(String status) {
    return _solicitudes.where((s) => s.status.name == status).length;
  }

  List<LoanApplicationModel> getSolicitudesByStatus(String status) {
    return _solicitudes.where((s) => s.status.name == status).toList();
  }

  List<LoanApplicationModel> getPendingSolicitudes() {
    return _solicitudes
        .where(
          (s) =>
              s.status == LoanApplicationStatus.draft ||
              s.status == LoanApplicationStatus.submitted,
        )
        .toList();
  }

  List<LoanApplicationModel> getReviewedSolicitudes() {
    return _solicitudes
        .where(
          (s) =>
              s.status == LoanApplicationStatus.approved ||
              s.status == LoanApplicationStatus.rejected,
        )
        .toList();
  }

  // ==================== PRIVATE METHODS ====================

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setSubmitting(bool value) {
    _isSubmitting = value;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }

  void reset() {
    _solicitudes = [];
    _currentSolicitud = null;
    _currentPage = 1;
    _hasMore = true;
    _statusFilter = null;
    _searchQuery = null;
    _error = null;
    notifyListeners();
  }
}
