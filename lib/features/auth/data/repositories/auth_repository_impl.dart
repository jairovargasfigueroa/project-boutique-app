import '../datasources/auth_datasource.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl {
  final AuthDatasource datasource;

  AuthRepositoryImpl({required this.datasource});

  Future<UserModel> login(String username, String password) async {
    return await datasource.login(username, password);
  }

  Future<UserModel> register({
    required String username,
    required String email,
    required String password,
    String? firstName,
    String? lastName,
  }) async {
    return await datasource.register(
      username: username,
      email: email,
      password: password,
      firstName: firstName,
      lastName: lastName,
    );
  }

  Future<void> logout(String token) async {
    return await datasource.logout(token);
  }
}
