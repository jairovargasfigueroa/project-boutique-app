import 'package:flutter/material.dart';
import '../../data/repositories/ventas_repository_impl.dart';

class CheckoutProvider extends ChangeNotifier {
  final VentasRepositoryImpl repository;

  CheckoutProvider({required this.repository});

  bool _isLoading = false;
  String? _error;
  Map<String, dynamic>? _ventaCreada;

  bool get isLoading => _isLoading;
  String? get error => _error;
  Map<String, dynamic>? get ventaCreada => _ventaCreada;

  Future<void> crearVenta(Map<String, dynamic> ventaData) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _ventaCreada = await repository.crearVenta(ventaData);
      _error = null;
    } catch (e) {
      _error = e.toString();
      _ventaCreada = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void limpiar() {
    _ventaCreada = null;
    _error = null;
    _isLoading = false;
    notifyListeners();
  }
}
