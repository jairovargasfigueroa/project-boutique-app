// lib/features/perfil/data/models/usuario_perfil_model.dart

class UsuarioPerfil {
  final int id;
  final String username;
  final String email;
  final String? firstName;
  final String? lastName;
  final String? rol;
  final String? telefono;

  UsuarioPerfil({
    required this.id,
    required this.username,
    required this.email,
    this.firstName,
    this.lastName,
    this.rol,
    this.telefono,
  });

  factory UsuarioPerfil.fromJson(Map<String, dynamic> json) {
    return UsuarioPerfil(
      id: json['id'] as int,
      username: json['username'] as String,
      email: json['email'] as String,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      rol: json['rol'] as String?,
      telefono: json['telefono'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
    };
  }

  String get nombreCompleto {
    final first = firstName ?? '';
    final last = lastName ?? '';
    if (first.isEmpty && last.isEmpty) {
      return username;
    }
    return '$first $last'.trim();
  }
}
