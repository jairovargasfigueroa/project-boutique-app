// lib/features/perfil/data/datasources/perfil_datasource.dart

import '../../../../core/services/api_service.dart';
import '../models/usuario_perfil_model.dart';

class PerfilDatasource {
  final ApiService _api = ApiService();

  // Obtener perfil del usuario (usa token del header automáticamente)
  Future<UsuarioPerfil> obtenerPerfil() async {
    try {
      final response = await _api.get('/usuarios/me/');
      return UsuarioPerfil.fromJson(response.data);
    } catch (e) {
      throw Exception('Error al obtener perfil: $e');
    }
  }

  // Actualizar perfil del usuario (usa token del header automáticamente)
  Future<UsuarioPerfil> actualizarPerfil(UsuarioPerfil perfil) async {
    try {
      final response = await _api.put('/usuarios/me/', {
        'email': perfil.email,
        'first_name': perfil.firstName,
        'last_name': perfil.lastName,
      });

      return UsuarioPerfil.fromJson(response.data);
    } catch (e) {
      throw Exception('Error al actualizar perfil: $e');
    }
  }
}
