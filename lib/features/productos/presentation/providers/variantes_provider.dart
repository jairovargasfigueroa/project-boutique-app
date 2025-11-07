import 'package:flutter/material.dart';
import '../../data/models/variante_producto_model.dart';
import '../../data/repositories/productos_repository_impl.dart';

class VariantesProvider extends ChangeNotifier {
  final ProductosRepositoryImpl repository;

  VariantesProvider({required this.repository});

  List<VarianteProducto> _variantes = [];
  bool _isLoading = false;
  String? _error;

  List<VarianteProducto> get variantes => _variantes;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> cargarVariantes(int productoId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _variantes = await repository.obtenerVariantes(productoId);
      _error = null;
    } catch (e) {
      _error = e.toString();
      _variantes = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void limpiar() {
    _variantes = [];
    _error = null;
    _isLoading = false;
    notifyListeners();
  }
}
