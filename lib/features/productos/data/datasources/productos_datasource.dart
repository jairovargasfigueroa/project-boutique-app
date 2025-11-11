import '../../../../core/services/api_service.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/producto_model.dart';
import '../models/variante_producto_model.dart';

class ProductosDatasource {
  final ApiService _apiService = ApiService();

  Future<List<ProductoModel>> getProductos({
    Map<String, dynamic>? filtros,
  }) async {
    try {
      print('🌐 Llamando a: ${ApiConstants.baseUrl}${ApiConstants.productos}');

      if (filtros != null && filtros.isNotEmpty) {
        print('📊 Con filtros: $filtros');
      }

      final response = await _apiService.get(
        ApiConstants.productos,
        queryParameters: filtros,
      );

      print('📡 Status Code: ${response.statusCode}');
      print('📄 Response Data: ${response.data}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = response.data as List<dynamic>;
        print('📋 JsonList Length: ${jsonList.length}');

        if (jsonList.isNotEmpty) {
          print('🔍 First Item: ${jsonList[0]}');
        }

        return jsonList.map((json) => ProductoModel.fromJson(json)).toList();
      } else {
        throw Exception('Error al cargar productos: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error en getProductos: $e');
      rethrow;
    }
  }

  // Obtener UN producto por ID
  Future<ProductoModel> obtenerProductoPorId(int id) async {
    try {
      final endpoint = '${ApiConstants.productos}$id/';
      print('🌐 Llamando a: ${ApiConstants.baseUrl}$endpoint');

      final response = await _apiService.get(endpoint);

      print('📡 Status Code: ${response.statusCode}');

      if (response.statusCode == 200) {
        return ProductoModel.fromJson(response.data);
      } else {
        throw Exception('Error al obtener producto: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error en obtenerProductoPorId: $e');
      rethrow;
    }
  }

  // Obtener variantes de un producto
  Future<List<VarianteProducto>> obtenerVariantes(int productoId) async {
    try {
      final endpoint = '${ApiConstants.productos}$productoId/variantes/';
      print('🌐 Llamando a: ${ApiConstants.baseUrl}$endpoint');

      final response = await _apiService.get(endpoint);

      print('📡 Status Code: ${response.statusCode}');
      print('📄 Response Data: ${response.data}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = response.data as List<dynamic>;
        return jsonList.map((json) => VarianteProducto.fromJson(json)).toList();
      } else {
        throw Exception('Error al obtener variantes: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error en obtenerVariantes: $e');
      rethrow;
    }
  }
}
