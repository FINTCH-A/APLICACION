import '../../core/api/api_client.dart';
import '../../core/api/api_endpoints.dart';
import '../models/prestamo_model.dart';
import '../models/solicitud_model.dart';
import '../models/cuota_model.dart';

class PrestamoRepository {
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

    // Extraer la data de la respuesta anidada
    dynamic data = response.data;

    // Navegar por la estructura { success, data: { success, data: { data: [...] } } }
    if (data['data'] != null && data['data'] is Map) {
      data = data['data'] as Map<String, dynamic>;
    }
    if (data['data'] != null && data['data'] is Map) {
      data = data['data'] as Map<String, dynamic>;
    }

    // Obtener la lista de datos
    List<dynamic> listData = [];
    if (data['data'] != null && data['data'] is List) {
      listData = data['data'] as List<dynamic>;
    } else if (data is List) {
      listData = data;
    } else {
      listData = [];
    }

    return listData.map((json) => LoanApplicationModel.fromJson(json)).toList();
  }

  Future<LoanApplicationModel> getLoanApplicationById(int id) async {
    final response = await _apiClient.get(
      '${ApiEndpoints.loanApplications}/$id',
    );

    dynamic data = response.data;
    if (data['data'] != null && data['data'] is Map) {
      data = data['data'] as Map<String, dynamic>;
    }
    if (data['data'] != null && data['data'] is Map) {
      data = data['data'] as Map<String, dynamic>;
    }

    return LoanApplicationModel.fromJson(data);
  }

  Future<LoanApplicationModel> createLoanApplication(
    CreateLoanApplicationDto dto,
  ) async {
    final response = await _apiClient.post(
      ApiEndpoints.loanApplications,
      data: dto.toJson(),
    );

    dynamic data = response.data;
    if (data['data'] != null && data['data'] is Map) {
      data = data['data'] as Map<String, dynamic>;
    }
    if (data['data'] != null && data['data'] is Map) {
      data = data['data'] as Map<String, dynamic>;
    }

    return LoanApplicationModel.fromJson(data);
  }

  Future<LoanApplicationModel> updateLoanApplication(
    int id,
    UpdateLoanApplicationDto dto,
  ) async {
    final response = await _apiClient.patch(
      '${ApiEndpoints.loanApplications}/$id',
      data: dto.toJson(),
    );

    dynamic data = response.data;
    if (data['data'] != null && data['data'] is Map) {
      data = data['data'] as Map<String, dynamic>;
    }
    if (data['data'] != null && data['data'] is Map) {
      data = data['data'] as Map<String, dynamic>;
    }

    return LoanApplicationModel.fromJson(data);
  }

  Future<LoanApplicationModel> submitLoanApplication(int id) async {
    final url = ApiEndpoints.replaceParam(
      ApiEndpoints.loanApplicationSubmit,
      'id',
      id.toString(),
    );
    final response = await _apiClient.patch(url);

    dynamic data = response.data;
    if (data['data'] != null && data['data'] is Map) {
      data = data['data'] as Map<String, dynamic>;
    }
    if (data['data'] != null && data['data'] is Map) {
      data = data['data'] as Map<String, dynamic>;
    }

    return LoanApplicationModel.fromJson(data);
  }

  Future<LoanApplicationModel> cancelLoanApplication(int id) async {
    final url = ApiEndpoints.replaceParam(
      ApiEndpoints.loanApplicationCancel,
      'id',
      id.toString(),
    );
    final response = await _apiClient.patch(url);

    dynamic data = response.data;
    if (data['data'] != null && data['data'] is Map) {
      data = data['data'] as Map<String, dynamic>;
    }
    if (data['data'] != null && data['data'] is Map) {
      data = data['data'] as Map<String, dynamic>;
    }

    return LoanApplicationModel.fromJson(data);
  }

  // ==================== LOANS ====================

  Future<List<LoanModel>> getLoans({
    int? page,
    int? limit,
    String? status,
  }) async {
    final queryParams = <String, dynamic>{};
    if (page != null) queryParams['page'] = page;
    if (limit != null) queryParams['limit'] = limit;
    if (status != null) queryParams['status'] = status;

    final response = await _apiClient.get(
      ApiEndpoints.loans,
      queryParameters: queryParams,
    );

    // Extraer la data de la respuesta anidada
    dynamic data = response.data;

    // Navegar por la estructura { success, data: { success, data: { data: [...] } } }
    if (data['data'] != null && data['data'] is Map) {
      data = data['data'] as Map<String, dynamic>;
    }
    if (data['data'] != null && data['data'] is Map) {
      data = data['data'] as Map<String, dynamic>;
    }

    // Obtener la lista de datos
    List<dynamic> listData = [];
    if (data['data'] != null && data['data'] is List) {
      listData = data['data'] as List<dynamic>;
    } else if (data is List) {
      listData = data;
    } else {
      listData = [];
    }

    return listData.map((json) => LoanModel.fromJson(json)).toList();
  }

  Future<LoanModel> getLoanById(int id) async {
    final response = await _apiClient.get('${ApiEndpoints.loans}/$id');

    dynamic data = response.data;
    if (data['data'] != null && data['data'] is Map) {
      data = data['data'] as Map<String, dynamic>;
    }
    if (data['data'] != null && data['data'] is Map) {
      data = data['data'] as Map<String, dynamic>;
    }

    return LoanModel.fromJson(data);
  }

  // ==================== INSTALLMENTS ====================

  Future<List<InstallmentModel>> getInstallments(int loanId) async {
    final url = ApiEndpoints.replaceParam(
      ApiEndpoints.installments,
      'loanId',
      loanId.toString(),
    );
    final response = await _apiClient.get(url);

    dynamic data = response.data;
    if (data['data'] != null && data['data'] is Map) {
      data = data['data'] as Map<String, dynamic>;
    }
    if (data['data'] != null && data['data'] is Map) {
      data = data['data'] as Map<String, dynamic>;
    }

    List<dynamic> listData = [];
    if (data['data'] != null && data['data'] is List) {
      listData = data['data'] as List<dynamic>;
    } else if (data is List) {
      listData = data;
    }

    return listData.map((json) => InstallmentModel.fromJson(json)).toList();
  }

  Future<InstallmentModel?> getNextDueInstallment(int loanId) async {
    final url = ApiEndpoints.replaceParam(
      ApiEndpoints.nextDueInstallment,
      'loanId',
      loanId.toString(),
    );
    try {
      final response = await _apiClient.get(url);

      dynamic data = response.data;
      if (data['data'] != null && data['data'] is Map) {
        data = data['data'] as Map<String, dynamic>;
      }
      if (data['data'] != null && data['data'] is Map) {
        data = data['data'] as Map<String, dynamic>;
      }

      return InstallmentModel.fromJson(data);
    } catch (e) {
      return null;
    }
  }

  Future<InstallmentModel> getInstallmentById(
    int loanId,
    int installmentId,
  ) async {
    final url = ApiEndpoints.replaceParam(
      ApiEndpoints.installments,
      'loanId',
      loanId.toString(),
    );
    final response = await _apiClient.get('$url/$installmentId');

    dynamic data = response.data;
    if (data['data'] != null && data['data'] is Map) {
      data = data['data'] as Map<String, dynamic>;
    }
    if (data['data'] != null && data['data'] is Map) {
      data = data['data'] as Map<String, dynamic>;
    }

    return InstallmentModel.fromJson(data);
  }
}
