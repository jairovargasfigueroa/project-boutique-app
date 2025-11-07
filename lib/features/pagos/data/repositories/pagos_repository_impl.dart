// lib/features/pagos/data/repositories/pagos_repository_impl.dart

import '../datasources/pagos_datasource.dart';
import '../models/pago_request_model.dart';

class PagosRepositoryImpl {
  final PagosDatasource datasource;

  PagosRepositoryImpl({required this.datasource});

  Future<Map<String, dynamic>> crearPago(PagoRequest pago) async {
    return await datasource.crearPago(pago);
  }
}
