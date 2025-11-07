// lib/features/pedidos/data/models/venta_model.dart

class Venta {
  final int id;
  final int? cliente;
  final String clienteNombre;
  final DateTime fecha;
  final String total;
  final String tipoPago;
  final String estadoPago;

  Venta({
    required this.id,
    this.cliente,
    required this.clienteNombre,
    required this.fecha,
    required this.total,
    required this.tipoPago,
    required this.estadoPago,
  });

  factory Venta.fromJson(Map<String, dynamic> json) {
    return Venta(
      id: json['id'],
      cliente: json['cliente'],
      clienteNombre: json['cliente_nombre'],
      fecha: DateTime.parse(json['fecha']),
      total: json['total'],
      tipoPago: json['tipo_pago'],
      estadoPago: json['estado_pago'],
    );
  }
}
