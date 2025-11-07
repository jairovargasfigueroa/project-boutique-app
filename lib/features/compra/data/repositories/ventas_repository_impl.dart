import '../datasources/ventas_datasource.dart';

class VentasRepositoryImpl {
  final VentasDatasource datasource;

  VentasRepositoryImpl({required this.datasource});

  Future<Map<String, dynamic>> crearVenta(
    Map<String, dynamic> ventaData,
  ) async {
    return await datasource.crearVenta(ventaData);
  }
}
