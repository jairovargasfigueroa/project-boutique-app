import 'categoria_model.dart';

class ProductoModel {
  final int id;
  final String nombre;
  final String descripcion;
  final int precioBase;
  final String? marca;
  final String? genero;
  final CategoriaModel? categoria;

  ProductoModel({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.precioBase,
    this.marca,
    this.genero,
    this.categoria,
  });

  factory ProductoModel.fromJson(Map<String, dynamic> json) {
    return ProductoModel(
      id: json['id'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      precioBase: json['precio_base'],
      marca: json['marca'], // Puede ser null si no viene en la API
      genero: json['genero'],
      categoria:
          json['categoria'] != null && json['categoria'] is Map
              ? CategoriaModel.fromJson(json['categoria'])
              : null, // Si categoria es int (ID), la ignoramos por ahora
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'precio_base': precioBase,
      'marca': marca,
      'genero': genero,
      'categoria': categoria?.toJson(),
    };
  }
}
