// lib/features/perfil/presentation/providers/perfil_provider.dart

import 'package:flutter/material.dart';
import '../../data/models/usuario_perfil_model.dart';
import '../../data/repositories/perfil_repository_impl.dart';

class PerfilProvider extends ChangeNotifier {
  final PerfilRepositoryImpl repository;

  PerfilProvider({required this.repository});

  UsuarioPerfil? _perfil;
  bool _isLoading = false;
  String? _errorMessage;

  UsuarioPerfil? get perfil => _perfil;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get tienePerfil => _perfil != null;

  // Cargar perfil
  Future<void> cargarPerfil() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _perfil = await repository.obtenerPerfil();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Actualizar perfil
  Future<bool> actualizarPerfil(UsuarioPerfil perfilActualizado) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _perfil = await repository.actualizarPerfil(perfilActualizado);
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
    _perfil = null;
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }
}
