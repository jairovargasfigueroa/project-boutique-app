import 'package:flutter/material.dart';
import '../../data/models/producto_model.dart';
import '../../data/repositories/productos_repository_impl.dart';

class ProductosProvider extends ChangeNotifier {
  final ProductosRepositoryImpl repository;

  ProductosProvider({required this.repository});

  List<ProductoModel> _productos = [];
  bool _isLoading = false;
  String? _error;
  Map<String, dynamic> _filtrosActivos = {};

  List<ProductoModel> get productos => _productos;
  bool get isLoading => _isLoading;
  String? get error => _error;
  Map<String, dynamic> get filtrosActivos => _filtrosActivos;

  Future<void> cargarProductos({Map<String, dynamic>? filtros}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      if (filtros != null) {
        _filtrosActivos = filtros;
      }

      _productos = await repository.getProductos(filtros: _filtrosActivos);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void aplicarFiltros(Map<String, dynamic> filtros) {
    cargarProductos(filtros: filtros);
  }

  void limpiarFiltros() {
    _filtrosActivos = {};
    cargarProductos();
  }
}
