// lib/features/pedidos/data/models/venta_model.dart

class Venta {
  final int id;
  final int cliente;
  final String clienteNombre;
  final DateTime fecha;
  final String total;
  final String tipoVenta;
  final String origen;
  final String estado;

  Venta({
    required this.id,
    required this.cliente,
    required this.clienteNombre,
    required this.fecha,
    required this.total,
    required this.tipoVenta,
    required this.origen,
    required this.estado,
  });

  factory Venta.fromJson(Map<String, dynamic> json) {
    return Venta(
      id: json['id'],
      cliente: json['cliente'],
      clienteNombre: json['cliente_nombre'],
      fecha: DateTime.parse(json['fecha']),
      total: json['total'],
      tipoVenta: json['tipo_venta'],
      origen: json['origen'],
      estado: json['estado'],
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

  String get fechaFormateada {
    final meses = [
      'Ene',
      'Feb',
      'Mar',
      'Abr',
      'May',
      'Jun',
      'Jul',
      'Ago',
      'Sep',
      'Oct',
      'Nov',
      'Dic',
    ];
    return '${fecha.day} ${meses[fecha.month - 1]} ${fecha.year}';
  }
}
