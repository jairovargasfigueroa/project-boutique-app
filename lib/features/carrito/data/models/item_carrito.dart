import '../../../productos/data/models/variante_producto_model.dart';

class ItemCarrito {
  final VarianteProducto variante;
  int cantidad;

  ItemCarrito({required this.variante, this.cantidad = 1});

  // Subtotal de este item
  double get subtotal => variante.precioVenta * cantidad;

  // Para enviar al backend
  Map<String, dynamic> toJson() {
    return {'variante_id': variante.id, 'cantidad': cantidad};
  }
}
