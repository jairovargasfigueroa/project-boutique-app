// lib/features/pagos/data/datasources/pagos_datasource.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pago_request_model.dart';

class PagosDatasource {
  final String baseUrl = 'http://192.168.1.9:8000/api';

  Future<Map<String, dynamic>> crearPago(PagoRequest pago) async {
    final url = Uri.parse('$baseUrl/pagos/');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(pago.toJson()),
      );

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Error al crear pago: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
}
