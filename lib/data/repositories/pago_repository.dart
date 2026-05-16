import '../../core/api/api_client.dart';
import '../../core/api/api_endpoints.dart';
import '../models/pago_model.dart';

class PagoRepository {
  final ApiClient _apiClient = ApiClient();

  Future<List<PaymentModel>> getPayments({
    int? page,
    int? limit,
    int? loanId,
    String? status,
  }) async {
    final queryParams = <String, dynamic>{};
    if (page != null) queryParams['page'] = page;
    if (limit != null) queryParams['limit'] = limit;
    if (loanId != null) queryParams['loanId'] = loanId;
    if (status != null) queryParams['status'] = status;

    final response = await _apiClient.get(
      ApiEndpoints.payments,
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

    return listData.map((json) => PaymentModel.fromJson(json)).toList();
  }

  Future<PaymentModel> getPaymentById(int id) async {
    final response = await _apiClient.get('${ApiEndpoints.payments}/$id');

    dynamic data = response.data;
    if (data['data'] != null && data['data'] is Map) {
      data = data['data'] as Map<String, dynamic>;
    }
    if (data['data'] != null && data['data'] is Map) {
      data = data['data'] as Map<String, dynamic>;
    }

    return PaymentModel.fromJson(data);
  }

  Future<PaymentModel> createPayment(CreatePaymentDto dto) async {
    final response = await _apiClient.post(
      ApiEndpoints.payments,
      data: dto.toJson(),
    );

    dynamic data = response.data;
    if (data['data'] != null && data['data'] is Map) {
      data = data['data'] as Map<String, dynamic>;
    }
    if (data['data'] != null && data['data'] is Map) {
      data = data['data'] as Map<String, dynamic>;
    }

    return PaymentModel.fromJson(data);
  }

  Future<PaymentModel> reversePayment(int id) async {
    final url = ApiEndpoints.replaceParam(
      ApiEndpoints.paymentReverse,
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

    return PaymentModel.fromJson(data);
  }
}
