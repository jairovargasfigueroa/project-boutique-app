import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/producto_model.dart';
import '../models/variante_producto_model.dart';

class ProductosDatasource {
  // URL base configurable
  static const String baseUrl = 'http://192.168.1.9:8000'; // CAMBIAR AQUÍ

  // Endpoint específico
  static const String productosEndpoint = '/api/productos'; // CAMBIAR AQUÍ

  Future<List<ProductoModel>> getProductos() async {
    final url = Uri.parse('$baseUrl$productosEndpoint');

    print('🌐 Llamando a: $url');

    final response = await http.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    print('📡 Status Code: ${response.statusCode}');
    print('📄 Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body);
      print('🔍 Decoded Data Type: ${decodedData.runtimeType}');
      print('🔍 Decoded Data: $decodedData');

      final List<dynamic> jsonList = decodedData as List<dynamic>;
      print('📋 JsonList Length: ${jsonList.length}');

      if (jsonList.isNotEmpty) {
        print('🔍 First Item Type: ${jsonList[0].runtimeType}');
        print('🔍 First Item: ${jsonList[0]}');
      }

      return jsonList.map((json) => ProductoModel.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar productos: ${response.statusCode}');
    }
  }

  // Obtener UN producto por ID
  Future<ProductoModel> obtenerProductoPorId(int id) async {
    final url = Uri.parse('$baseUrl$productosEndpoint/$id/');

    print('🌐 Llamando a: $url');

    final response = await http.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    print('📡 Status Code: ${response.statusCode}');

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return ProductoModel.fromJson(jsonData);
    } else {
      throw Exception('Error al obtener producto: ${response.statusCode}');
    }
  }

  // Obtener variantes de un producto
  Future<List<VarianteProducto>> obtenerVariantes(int productoId) async {
    final url = Uri.parse(
      '$baseUrl$productosEndpoint/$productoId/variantes/',
    );

    print('🌐 Llamando a: $url');

    final response = await http.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    print('📡 Status Code: ${response.statusCode}');
    print('📄 Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => VarianteProducto.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener variantes: ${response.statusCode}');
    }
  }
}
