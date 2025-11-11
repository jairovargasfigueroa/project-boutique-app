class VarianteProducto {
  final int id;
  final int productoId;
  final String productoNombre;
  final String? talla;
  final String precio;
  final int stock;
  final int stockMinimo;
  final bool hayStock;
  final bool stockBajo;

  VarianteProducto({
    required this.id,
    required this.productoId,
    required this.productoNombre,
    this.talla,
    required this.precio,
    required this.stock,
    required this.stockMinimo,
    required this.hayStock,
    required this.stockBajo,
  });

  // Convertir JSON a Modelo
  factory VarianteProducto.fromJson(Map<String, dynamic> json) {
    return VarianteProducto(
      id: json['id'],
      productoId: json['producto'],
      productoNombre: json['producto_nombre'],
      talla: json['talla'],
      precio: json['precio'].toString(),
      stock: json['stock'],
      stockMinimo: json['stock_minimo'],
      hayStock: json['hay_stock'],
      stockBajo: json['stock_bajo'],
    );
  }

  // Convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'producto': productoId,
      'producto_nombre': productoNombre,
      'talla': talla,
      'precio': precio,
      'stock': stock,
      'stock_minimo': stockMinimo,
      'hay_stock': hayStock,
      'stock_bajo': stockBajo,
    };
  }

  // Helpers
  bool get tieneStock => hayStock;
  bool get esBajoStock => stockBajo;

  // Obtener precio como double para cálculos
  double get precioNumerico => double.parse(precio);
}
