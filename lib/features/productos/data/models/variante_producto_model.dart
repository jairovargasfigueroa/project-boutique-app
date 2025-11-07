class VarianteProducto {
  final int id;
  final int productoId;
  final String talla;
  final String color;
  final double precioVenta;
  final double precioCosto;
  final String? imagen;
  final int stock;
  final int stockMinimo;

  VarianteProducto({
    required this.id,
    required this.productoId,
    required this.talla,
    required this.color,
    required this.precioVenta,
    required this.precioCosto,
    this.imagen,
    required this.stock,
    required this.stockMinimo,
  });

  // Convertir JSON a Modelo
  factory VarianteProducto.fromJson(Map<String, dynamic> json) {
    return VarianteProducto(
      id: json['id'],
      productoId: json['producto'],
      talla: json['talla'],
      color: json['color'],
      precioVenta:
          json['precio_venta'] is String
              ? double.parse(json['precio_venta'])
              : (json['precio_venta'] as num).toDouble(),
      precioCosto:
          json['precio_costo'] is String
              ? double.parse(json['precio_costo'])
              : (json['precio_costo'] as num).toDouble(),
      imagen: json['imagen'],
      stock: json['stock'],
      stockMinimo: json['stock_minimo'],
    );
  }

  // Helpers
  bool get tieneStock => stock > 0;
  bool get esBajoStock => stock <= stockMinimo;
}
