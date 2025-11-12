import 'package:flutter/material.dart';
import '../../../productos/data/models/variante_producto_model.dart';
import '../../data/models/item_carrito.dart';

class CarritoProvider extends ChangeNotifier {
  final List<ItemCarrito> _items = [];

  List<ItemCarrito> get items => _items;
  int get cantidadTotal => _items.fold(0, (sum, item) => sum + item.cantidad);
  double get total => _items.fold(0, (sum, item) => sum + item.subtotal);
  bool get estaVacio => _items.isEmpty;


  // Agregar variante al carrito
  void agregarVariante(VarianteProducto variante, {int cantidad = 1}) {
    final index = _items.indexWhere((item) => item.variante.id == variante.id);

    if (index != -1) {
      // Ya existe, aumentar cantidad
      _items[index].cantidad += cantidad;
    } else {
      // No existe, agregar nuevo
      _items.add(ItemCarrito(variante: variante, cantidad: cantidad));
    }

    notifyListeners();
  }

  // Aumentar cantidad
  void aumentarCantidad(int varianteId) {
    final index = _items.indexWhere((item) => item.variante.id == varianteId);
    if (index != -1) {
      _items[index].cantidad++;
      notifyListeners();
    }
  }

  // Disminuir cantidad
  void disminuirCantidad(int varianteId) {
    final index = _items.indexWhere((item) => item.variante.id == varianteId);
    if (index != -1) {
      if (_items[index].cantidad > 1) {
        _items[index].cantidad--;
      } else {
        eliminarVariante(varianteId);
      }
      notifyListeners();
    }
  }

  // Eliminar variante
  void eliminarVariante(int varianteId) {
    _items.removeWhere((item) => item.variante.id == varianteId);
    notifyListeners();
  }

  // Limpiar carrito
  void limpiar() {
    _items.clear();
    notifyListeners();
  }

  // Preparar datos para enviar al backend
  Map<String, dynamic> prepararVenta({
    String tipoVenta = 'contado', // Por defecto "contado" para ventas online
    String origen = 'ecommerce', // Por defecto "ecommerce" para ventas online
  }) {
    return {
      'tipo_venta': tipoVenta,
      'origen': origen,
      'items': _items.map((item) => item.toJson()).toList(),
    };
  }
}
