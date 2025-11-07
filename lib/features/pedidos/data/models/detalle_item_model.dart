// lib/features/pedidos/data/models/detalle_item_model.dart

class DetalleItem {
  final int id;
  final int variante;
  final int cantidad;
  final String precioUnitario;
  final String subtotal;
  final String productoNombre;
  final String talla;
  final String color;

  DetalleItem({
    required this.id,
    required this.variante,
    required this.cantidad,
    required this.precioUnitario,
    required this.subtotal,
    required this.productoNombre,
    required this.talla,
    required this.color,
  });

  factory DetalleItem.fromJson(Map<String, dynamic> json) {
    return DetalleItem(
      id: json['id'],
      variante: json['variante'],
      cantidad: json['cantidad'],
      precioUnitario: json['precio_unitario'],
      subtotal: json['subtotal'],
      productoNombre: json['producto_nombre'],
      talla: json['talla'],
      color: json['color'],
    );
  }
}
