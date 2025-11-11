// lib/features/pedidos/data/models/detalle_item_model.dart

class DetalleItem {
  final int id;
  final int varianteProducto;
  final int cantidad;
  final String precioUnitario;
  final String subTotal;
  final String nombreProducto;
  final String? talla; // Opcional

  DetalleItem({
    required this.id,
    required this.varianteProducto,
    required this.cantidad,
    required this.precioUnitario,
    required this.subTotal,
    required this.nombreProducto,
    this.talla,
  });

  factory DetalleItem.fromJson(Map<String, dynamic> json) {
    return DetalleItem(
      id: json['id'],
      varianteProducto: json['variante_producto'],
      cantidad: json['cantidad'],
      precioUnitario: json['precio_unitario'],
      subTotal: json['sub_total'],
      nombreProducto: json['nombre_producto'],
      talla: json['talla'],
    );
  }

  // Helpers para la UI
  String get precioFormateado => '\$${precioUnitario}';
  String get subTotalFormateado => '\$${subTotal}';
  String get tallaTexto => talla ?? 'Única';
}
