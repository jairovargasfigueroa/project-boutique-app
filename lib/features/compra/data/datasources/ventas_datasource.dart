import 'dart:convert';
import 'package:http/http.dart' as http;

class VentasDatasource {
  static const String baseUrl = 'http://192.168.1.9:8000';

  Future<Map<String, dynamic>> crearVenta(
    Map<String, dynamic> ventaData,
  ) async {
    final url = Uri.parse('$baseUrl/api/ventas/crear/');

    print('🌐 Creando venta en: $url');
    print('📤 Datos: $ventaData');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(ventaData),
    );

    print('📡 Status Code: ${response.statusCode}');
    print('📄 Response Body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al crear venta: ${response.statusCode}');
    }
  }
}
