// lib/features/pedidos/presentation/providers/pedidos_provider.dart

import 'package:flutter/material.dart';
import '../../data/models/venta_model.dart';
import '../../data/repositories/pedidos_repository_impl.dart';

class PedidosProvider extends ChangeNotifier {
  final PedidosRepositoryImpl repository;

  PedidosProvider({required this.repository});

  List<Venta> _ventas = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Venta> get ventas => _ventas;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get tieneVentas => _ventas.isNotEmpty;

  Future<void> cargarVentas() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _ventas = await repository.obtenerVentas();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  void reset() {
    _ventas = [];
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }
}
