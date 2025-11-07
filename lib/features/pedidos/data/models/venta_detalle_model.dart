// lib/features/pedidos/data/models/venta_detalle_model.dart

import 'detalle_item_model.dart';

class VentaDetalle {
  final int id;
  final int? cliente;
  final String clienteNombre;
  final DateTime fecha;
  final String total;
  final String tipoPago;
  final String estadoPago;
  final String? interes;
  final String? totalConInteres;
  final int? plazoMeses;
  final String? cuotaMensual;
  final List<DetalleItem> detalles;

  VentaDetalle({
    required this.id,
    this.cliente,
    required this.clienteNombre,
    required this.fecha,
    required this.total,
    required this.tipoPago,
    required this.estadoPago,
    this.interes,
    this.totalConInteres,
    this.plazoMeses,
    this.cuotaMensual,
    required this.detalles,
  });

  factory VentaDetalle.fromJson(Map<String, dynamic> json) {
    return VentaDetalle(
      id: json['id'],
      cliente: json['cliente'],
      clienteNombre: json['cliente_nombre'],
      fecha: DateTime.parse(json['fecha']),
      total: json['total'],
      tipoPago: json['tipo_pago'],
      estadoPago: json['estado_pago'],
      interes: json['interes'],
      totalConInteres: json['total_con_interes'],
      plazoMeses: json['plazo_meses'],
      cuotaMensual: json['cuota_mensual'],
      detalles:
          (json['detalles'] as List)
              .map((item) => DetalleItem.fromJson(item))
              .toList(),
    );
  }
}
