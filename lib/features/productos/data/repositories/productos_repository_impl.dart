import '../datasources/productos_datasource.dart';
import '../models/producto_model.dart';
import '../models/variante_producto_model.dart';

class ProductosRepositoryImpl {
  final ProductosDatasource datasource;

  ProductosRepositoryImpl({required this.datasource});

  Future<List<ProductoModel>> getProductos() async {
    return await datasource.getProductos();
  }

  Future<ProductoModel> obtenerProductoPorId(int id) async {
    return await datasource.obtenerProductoPorId(id);
  }

  Future<List<VarianteProducto>> obtenerVariantes(int productoId) async {
    return await datasource.obtenerVariantes(productoId);
  }
}
