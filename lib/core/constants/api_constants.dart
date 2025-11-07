// lib/core/constants/api_constants.dart

class ApiConstants {
  // Base URL
  static const String baseUrl = 'http://192.168.1.9:8000/api';

  // Auth endpoints
  static const String login = '/auth/login/';
  static const String register = '/auth/register/';

  // Productos endpoints
  static const String productos = '/productos/';
  static const String productoVariantes = '/producto-variante/';

  // Ventas endpoints
  static const String ventas = '/ventas/';
  static const String misPedidos = '/ventas/mis-pedidos/';

  // Pagos endpoints
  static const String pagos = '/pagos/';
}
