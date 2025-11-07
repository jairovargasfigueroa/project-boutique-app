// lib/features/pagos/data/models/pago_request_model.dart

class PagoRequest {
  final int venta;
  final double montoPagado;
  final String metodoPago; // efectivo, qr, tarjeta
  final String referenciaPago;

  PagoRequest({
    required this.venta,
    required this.montoPagado,
    required this.metodoPago,
    required this.referenciaPago,
  });

  Map<String, dynamic> toJson() {
    return {
      'venta': venta,
      'monto_pagado': montoPagado,
      'metodo_pago': metodoPago,
      'referencia_pago': referenciaPago,
    };
  }
}
