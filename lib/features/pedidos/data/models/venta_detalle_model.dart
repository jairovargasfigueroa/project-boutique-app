// lib/features/pedidos/data/models/venta_detalle_model.dart

import 'detalle_item_model.dart';

class VentaDetalle {
  final int id;
  final int cliente;
  final String clienteNombre;
  final int? vendedor;
  final String? vendedorNombre;
  final DateTime fecha;
  final String total;
  final String tipoVenta;
  final String origen;
  final String estado;
  final String? interes;
  final String? totalConInteres;
  final int? plazoMeses;
  final String? cuotaMensual;
  final List<DetalleItem> detalles;

  VentaDetalle({
    required this.id,
    required this.cliente,
    required this.clienteNombre,
    this.vendedor,
    this.vendedorNombre,
    required this.fecha,
    required this.total,
    required this.tipoVenta,
    required this.origen,
    required this.estado,
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
      vendedor: json['vendedor'],
      vendedorNombre: json['vendedor_nombre'],
      fecha: DateTime.parse(json['fecha']),
      total: json['total'],
      tipoVenta: json['tipo_venta'],
      origen: json['origen'],
      estado: json['estado'],
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

  // Helpers para la UI
  String get totalFormateado => 'Bs. $total';

  String get estadoTexto {
    switch (estado) {
      case 'completado':
        return 'Completado';
      case 'pendiente':
        return 'Pendiente';
      case 'cancelado':
        return 'Cancelado';
      default:
        return estado;
    }
  }

  bool get esContado => tipoVenta == 'contado';
  bool get esCredito => tipoVenta == 'credito';
}
