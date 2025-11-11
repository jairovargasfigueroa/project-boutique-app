// lib/features/pedidos/data/datasources/pedidos_datasource.dart

import '../../../../core/services/api_service.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/venta_model.dart';
import '../models/venta_detalle_model.dart';

class PedidosDatasource {
  final ApiService _apiService = ApiService();

  // Obtener lista de ventas (mis pedidos del usuario autenticado)
  Future<List<Venta>> obtenerMisPedidos() async {
    try {
      print(
        '🌐 Obteniendo pedidos: ${ApiConstants.baseUrl}${ApiConstants.misPedidos}',
      );

      final response = await _apiService.get(ApiConstants.misPedidos);

      print('📡 Status Code: ${response.statusCode}');
      print('📄 Response Data: ${response.data}');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List<dynamic>;
        return data.map((json) => Venta.fromJson(json)).toList();
      } else {
        throw Exception('Error al obtener ventas: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error en obtenerVentas: $e');
      rethrow;
    }
  }

  // Obtener detalle de una venta específica
  Future<VentaDetalle> obtenerVentaDetalle(int ventaId) async {
    try {
      final endpoint = '${ApiConstants.ventas}$ventaId/';
      print('🌐 Obteniendo detalle: ${ApiConstants.baseUrl}$endpoint');

      final response = await _apiService.get(endpoint);

      print('📡 Status Code: ${response.statusCode}');
      print('📄 Response Data: ${response.data}');

      if (response.statusCode == 200) {
        return VentaDetalle.fromJson(response.data);
      } else {
        throw Exception('Error al obtener detalle: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error en obtenerVentaDetalle: $e');
      rethrow;
    }
  }
}
