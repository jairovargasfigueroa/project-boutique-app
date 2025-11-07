// lib/features/pedidos/data/datasources/pedidos_datasource.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/venta_model.dart';
import '../models/venta_detalle_model.dart';

class PedidosDatasource {
  final String baseUrl = 'http://192.168.1.9:8000/api';

  // Obtener lista de ventas
  Future<List<Venta>> obtenerVentas() async {
    final url = Uri.parse('$baseUrl/ventas/');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Venta.fromJson(json)).toList();
      } else {
        throw Exception('Error al obtener ventas: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Obtener detalle de una venta específica
  Future<VentaDetalle> obtenerVentaDetalle(int ventaId) async {
    final url = Uri.parse('$baseUrl/ventas/$ventaId/');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return VentaDetalle.fromJson(data);
      } else {
        throw Exception('Error al obtener detalle: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
}
