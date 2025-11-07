// lib/features/pedidos/data/repositories/pedidos_repository_impl.dart

import '../datasources/pedidos_datasource.dart';
import '../models/venta_model.dart';
import '../models/venta_detalle_model.dart';

class PedidosRepositoryImpl {
  final PedidosDatasource datasource;

  PedidosRepositoryImpl({required this.datasource});

  Future<List<Venta>> obtenerVentas() async {
    return await datasource.obtenerVentas();
  }

  Future<VentaDetalle> obtenerVentaDetalle(int ventaId) async {
    return await datasource.obtenerVentaDetalle(ventaId);
  }
}
