// lib/features/pagos/presentation/providers/pago_provider.dart

import 'package:flutter/material.dart';
import '../../data/models/pago_request_model.dart';
import '../../data/repositories/pagos_repository_impl.dart';

class PagoProvider extends ChangeNotifier {
  final PagosRepositoryImpl repository;

  PagoProvider({required this.repository});

  bool _isLoading = false;
  String? _errorMessage;
  Map<String, dynamic>? _pagoCreado;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Map<String, dynamic>? get pagoCreado => _pagoCreado;

  Future<bool> crearPago(PagoRequest pago) async {
    _isLoading = true;
    _errorMessage = null;
    _pagoCreado = null;
    notifyListeners();

    try {
      _pagoCreado = await repository.crearPago(pago);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void reset() {
    _isLoading = false;
    _errorMessage = null;
    _pagoCreado = null;
    notifyListeners();
  }
}
