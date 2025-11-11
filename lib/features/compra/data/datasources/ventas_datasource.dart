import '../../../../core/services/api_service.dart';
import '../../../../core/constants/api_constants.dart';

class VentasDatasource {
  final ApiService _apiService = ApiService();

  Future<Map<String, dynamic>> crearVenta(
    Map<String, dynamic> ventaData,
  ) async {
    try {
      print(
        '🌐 Creando venta en: ${ApiConstants.baseUrl}${ApiConstants.ventas}crear/',
      );
      print('📤 Datos: $ventaData');

      final response = await _apiService.post(
        '${ApiConstants.ventas}crear/',
        ventaData,
      );

      print('📡 Status Code: ${response.statusCode}');
      print('📄 Response Data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception('Error al crear venta: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error en crearVenta: $e');
      rethrow;
    }
  }
}
