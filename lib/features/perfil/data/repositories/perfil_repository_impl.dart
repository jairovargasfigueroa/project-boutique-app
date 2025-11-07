// lib/features/perfil/data/repositories/perfil_repository_impl.dart

import '../datasources/perfil_datasource.dart';
import '../models/usuario_perfil_model.dart';

class PerfilRepositoryImpl {
  final PerfilDatasource datasource;

  PerfilRepositoryImpl({required this.datasource});

  Future<UsuarioPerfil> obtenerPerfil() async {
    return await datasource.obtenerPerfil();
  }

  Future<UsuarioPerfil> actualizarPerfil(UsuarioPerfil perfil) async {
    return await datasource.actualizarPerfil(perfil);
  }
}
