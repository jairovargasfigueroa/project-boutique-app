class VentaRequest {
  final List<ItemVenta> items;
  final String tipoPago;

  VentaRequest({required this.items, required this.tipoPago});

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((item) => item.toJson()).toList(),
      'tipo_pago': tipoPago,
    };
  }
}

class ItemVenta {
  final int varianteId;
  final int cantidad;

  ItemVenta({required this.varianteId, required this.cantidad});

  Map<String, dynamic> toJson() {
    return {'variante_id': varianteId, 'cantidad': cantidad};
  }
}
