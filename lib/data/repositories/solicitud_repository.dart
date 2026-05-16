import '../../core/api/api_client.dart';
import '../../core/api/api_endpoints.dart';
import '../models/solicitud_model.dart';

class SolicitudRepository {
  final ApiClient _apiClient = ApiClient();

  // ==================== LOAN APPLICATIONS ====================

  Future<List<LoanApplicationModel>> getLoanApplications({
    int? page,
    int? limit,
    String? status,
    String? search,
  }) async {
    final queryParams = <String, dynamic>{};
    if (page != null) queryParams['page'] = page;
    if (limit != null) queryParams['limit'] = limit;
    if (status != null) queryParams['status'] = status;
    if (search != null && search.isNotEmpty) queryParams['search'] = search;

    final response = await _apiClient.get(
      ApiEndpoints.loanApplications,
      queryParameters: queryParams,
    );

    // Si la respuesta es paginada
    if (response.data['data'] != null) {
      final data = response.data['data'] as List;
      return data.map((json) => LoanApplicationModel.fromJson(json)).toList();
    }

    // Si la respuesta es un array directo
    if (response.data is List) {
      final data = response.data as List;
      return data.map((json) => LoanApplicationModel.fromJson(json)).toList();
    }

    return [];
  }

  Future<LoanApplicationModel> getLoanApplicationById(int id) async {
    final response = await _apiClient.get(
      '${ApiEndpoints.loanApplications}/$id',
    );
    return LoanApplicationModel.fromJson(response.data);
  }

  Future<LoanApplicationModel> createLoanApplication(
    CreateLoanApplicationDto dto,
  ) async {
    final response = await _apiClient.post(
      ApiEndpoints.loanApplications,
      data: dto.toJson(),
    );
    return LoanApplicationModel.fromJson(response.data);
  }

  Future<LoanApplicationModel> updateLoanApplication(
    int id,
    UpdateLoanApplicationDto dto,
  ) async {
    final response = await _apiClient.patch(
      '${ApiEndpoints.loanApplications}/$id',
      data: dto.toJson(),
    );
    return LoanApplicationModel.fromJson(response.data);
  }

  Future<LoanApplicationModel> submitLoanApplication(int id) async {
    final url = ApiEndpoints.replaceParam(
      ApiEndpoints.loanApplicationSubmit,
      'id',
      id.toString(),
    );
    final response = await _apiClient.patch(url);
    return LoanApplicationModel.fromJson(response.data);
  }

  Future<LoanApplicationModel> reviewLoanApplication(
    int id,
    ReviewLoanApplicationDto dto,
  ) async {
    final url = ApiEndpoints.replaceParam(
      ApiEndpoints.loanApplicationReview,
      'id',
      id.toString(),
    );
    final response = await _apiClient.patch(url, data: dto.toJson());
    return LoanApplicationModel.fromJson(response.data);
  }

  Future<LoanApplicationModel> cancelLoanApplication(int id) async {
    final url = ApiEndpoints.replaceParam(
      ApiEndpoints.loanApplicationCancel,
      'id',
      id.toString(),
    );
    final response = await _apiClient.patch(url);
    return LoanApplicationModel.fromJson(response.data);
  }

  // ==================== BULK OPERATIONS ====================

  Future<void> deleteMultiple(List<int> ids) async {
    // Implementar según necesidad del backend
    for (final id in ids) {
      await cancelLoanApplication(id);
    }
  }
}
