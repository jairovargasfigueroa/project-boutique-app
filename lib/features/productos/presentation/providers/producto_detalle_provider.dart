import 'package:flutter/material.dart';
import '../../data/models/producto_model.dart';
import '../../data/repositories/productos_repository_impl.dart';

class ProductoDetalleProvider extends ChangeNotifier {
  final ProductosRepositoryImpl repository;

  ProductoDetalleProvider({required this.repository});

  ProductoModel? _producto;
  bool _isLoading = false;
  String? _error;

  ProductoModel? get producto => _producto;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> cargarProducto(int productoId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _producto = await repository.obtenerProductoPorId(productoId);
      _error = null;
    } catch (e) {
      _error = e.toString();
      _producto = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void limpiar() {
    _producto = null;
    _error = null;
    _isLoading = false;
    notifyListeners();
  }
}
