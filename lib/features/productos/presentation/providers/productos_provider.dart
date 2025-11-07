import 'package:flutter/material.dart';
import '../../data/models/producto_model.dart';
import '../../data/repositories/productos_repository_impl.dart';

class ProductosProvider extends ChangeNotifier {
  final ProductosRepositoryImpl repository;

  ProductosProvider({required this.repository});

  List<ProductoModel> _productos = [];
  bool _isLoading = false;
  String? _error;

  List<ProductoModel> get productos => _productos;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> cargarProductos() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _productos = await repository.getProductos();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
