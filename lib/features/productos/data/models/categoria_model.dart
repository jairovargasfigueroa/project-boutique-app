class CategoriaModel {
  final int id;
  final String nombre;

  CategoriaModel({
    required this.id,
    required this.nombre,
  });

  factory CategoriaModel.fromJson(Map<String, dynamic> json) {
    return CategoriaModel(
      id: json['id'],
      nombre: json['nombre'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
    };
  }
}