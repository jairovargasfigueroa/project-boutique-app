class ProductoModel {
  final int id;
  final String nombre;
  final int categoria;
  final String categoriaNombre;
  final String genero;
  final String descripcion;
  final String? marca;
  final String imagenUrl;
  final int stock;

  ProductoModel({
    required this.id,
    required this.nombre,
    required this.categoria,
    required this.categoriaNombre,
    required this.genero,
    required this.descripcion,
    this.marca,
    required this.imagenUrl,
    required this.stock,
  });

  factory ProductoModel.fromJson(Map<String, dynamic> json) {
    return ProductoModel(
      id: json['id'],
      nombre: json['nombre'],
      categoria: json['categoria'],
      categoriaNombre: json['categoria_nombre'],
      genero: json['genero'],
      descripcion: json['descripcion'],
      marca: json['marca'],
      imagenUrl: json['image'], // El backend devuelve 'image'
      stock: json['stock'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'categoria': categoria,
      'categoria_nombre': categoriaNombre,
      'genero': genero,
      'descripcion': descripcion,
      'marca': marca,
      'image': imagenUrl, // Mantenemos consistencia con el backend
      'stock': stock,
    };
  }
}
