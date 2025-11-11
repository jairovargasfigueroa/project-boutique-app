// lib/features/pagos/data/datasources/pagos_datasource.dart

import '../../../../core/services/api_service.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/pago_request_model.dart';

class PagosDatasource {
  final ApiService _apiService = ApiService();

  Future<Map<String, dynamic>> crearPago(PagoRequest pago) async {
    try {
      print('🌐 Creando pago en: ${ApiConstants.baseUrl}${ApiConstants.pagos}');
      print('📤 Datos: ${pago.toJson()}');

      final response = await _apiService.post(
        ApiConstants.pagos,
        pago.toJson(),
      );

      print('📡 Status Code: ${response.statusCode}');
      print('📄 Response Data: ${response.data}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception('Error al crear pago: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error en crearPago: $e');
      rethrow;
    }
  }
}
