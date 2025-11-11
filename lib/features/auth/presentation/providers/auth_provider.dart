import 'package:flutter/material.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/services/notification_service.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository_impl.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepositoryImpl repository;
  final StorageService storage;

  AuthProvider({required this.repository, required this.storage}) {
    // Al crearse, verificar si hay sesión guardada
    _checkSession();
  }

  UserModel? _user;
  bool _isLoading = false;
  String? _error;
  bool _isAuthenticated = false;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _isAuthenticated;

  // Verificar si hay sesión guardada
  Future<void> _checkSession() async {
    try {
      if (await storage.hasToken()) {
        final token = await storage.getToken();
        final userData = await storage.getUser();

        if (token != null && userData != null && userData['id'] != null) {
          _user = UserModel(
            id: userData['id'] as int,
            username: userData['nombre'] as String? ?? '',
            email: userData['email'] as String? ?? '',
            token: token,
          );
          _isAuthenticated = true;
          notifyListeners();
        }
      }
    } catch (e) {
      // Si hay error al cargar sesión, continuar sin autenticar
      print('Error al cargar sesión: $e');
    }
  }

  Future<void> login(String username, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _user = await repository.login(username, password);
      _isAuthenticated = true;

      // Guardar sesión en storage
      if (_user?.token != null) {
        await storage.saveToken(_user!.token!);
        if (_user!.refreshtoken != null) {
          await storage.saveRefreshToken(_user!.refreshtoken!);
        }
        await storage.saveUser(
          id: _user!.id,
          nombre: _user!.username,
          email: _user!.email,
        );

        // Generar nuevo token FCM para este usuario
        await NotificationService.forceTokenRefreshAndSend();
      }
    } catch (e) {
      _error = e.toString();
      _isAuthenticated = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> register({
    required String username,
    required String email,
    required String password,
    String? firstName,
    String? lastName,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _user = await repository.register(
        username: username,
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
      );
      _isAuthenticated = true;

      // Guardar sesión en storage
      if (_user?.token != null) {
        await storage.saveToken(_user!.token!);
        if (_user!.refreshtoken != null) {
          await storage.saveRefreshToken(_user!.refreshtoken!);
        }
        await storage.saveUser(
          id: _user!.id,
          nombre: _user!.username,
          email: _user!.email,
        );
      }
    } catch (e) {
      _error = e.toString();
      _isAuthenticated = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Obtener refresh token del storage
      final refreshToken = await storage.getRefreshToken();

      if (refreshToken != null) {
        await repository.logout(refreshToken);
      }

      // Limpiar storage
      await storage.clear();

      _user = null;
      _isAuthenticated = false;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
