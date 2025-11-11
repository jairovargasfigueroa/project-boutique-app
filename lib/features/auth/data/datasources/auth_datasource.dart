import '../../../../core/services/api_service.dart';
import '../models/user_model.dart';

class AuthDatasource {
  final ApiService _api = ApiService();

  Future<UserModel> login(String username, String password) async {
    try {
      final response = await _api.post('/usuarios/login/', {
        'username': username,
        'password': password,
      });

      // El usuario está dentro de "user"
      final userData = response.data['user'];
      // Agregar el token de acceso al userData
      userData['token'] = response.data['access'];
      userData['refreshtoken'] = response.data['refresh'];

      return UserModel.fromJson(userData);
    } catch (e) {
      throw Exception('Error al iniciar sesión: $e');
    }
  }

  Future<UserModel> register({
    required String username,
    required String email,
    required String password,
    String? firstName,
    String? lastName,
  }) async {
    try {
      final response = await _api.post('/usuarios/registro/', {
        'username': username,
        'email': email,
        'password': password,
        'first_name': firstName,
        'last_name': lastName,
      });

      // El usuario está dentro de "user"
      final userData = response.data['user'];
      // Agregar los tokens al userData
      userData['token'] = response.data['access'];
      userData['refreshtoken'] = response.data['refresh'];

      return UserModel.fromJson(userData);
    } catch (e) {
      throw Exception('Error al registrar usuario: $e');
    }
  }

  Future<void> logout(String refreshToken) async {
    try {
      // Enviar el refresh token al backend para invalidarlo
      await _api.post('/usuarios/logout/', {'refresh': refreshToken});
    } catch (e) {
      throw Exception('Error al cerrar sesión: $e');
    }
  }
}
