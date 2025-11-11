// lib/core/router/app_router.dart

import 'package:boutique_app/features/productos/presentation/screens/productos_list_screen.dart';
import 'package:boutique_app/features/productos/presentation/screens/producto_detalle_screen.dart';
import 'package:boutique_app/features/carrito/presentation/screens/carrito_screen.dart';
import 'package:boutique_app/features/compra/presentation/screens/checkout_screen.dart';
import 'package:boutique_app/features/pagos/presentation/screens/pago_screen.dart';
import 'package:boutique_app/features/pedidos/presentation/screens/pedidos_list_screen.dart';
import 'package:boutique_app/features/pedidos/presentation/screens/pedido_detalle_screen.dart';
import 'package:boutique_app/features/perfil/presentation/screens/perfil_screen.dart';
import 'package:boutique_app/features/perfil/presentation/screens/editar_perfil_screen.dart';
import 'package:boutique_app/features/auth/presentation/screens/login_screen.dart';
import 'package:boutique_app/features/auth/presentation/screens/register_screen.dart';
import 'package:go_router/go_router.dart';
import 'scaffold_with_nav.dart';
import '../services/storage_service.dart';

final GoRouter appRouter = GoRouter(
  debugLogDiagnostics: true, // ← Ver logs en consola
  initialLocation: '/productos',

  // 🔒 Guard para proteger rutas que requieren autenticación
  redirect: (context, state) async {
    final storage = StorageService();
    final isLoggedIn = await storage.hasToken();

    // Rutas que requieren autenticación
    final rutasProtegidas = [
      '/checkout',
      '/pagos',
      '/pedidos/detalle',
      '/perfil/editar',
    ];

    final estaEnRutaProtegida = rutasProtegidas.any(
      (ruta) => state.matchedLocation.startsWith(ruta),
    );

    // Si intenta acceder a ruta protegida sin autenticación → login
    if (!isLoggedIn && estaEnRutaProtegida) {
      return '/login';
    }

    // Si está logueado e intenta ir a login/register → productos
    if (isLoggedIn &&
        (state.matchedLocation == '/login' ||
            state.matchedLocation == '/register')) {
      return '/productos';
    }

    return null; // Permitir navegación
  },

  routes: [
    // 🏠 Shell con Tabs
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ScaffoldWithNavBar(navigationShell: navigationShell);
      },
      branches: [
        // TAB 0: Productos
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/productos',
              builder: (context, state) => const ProductosListScreen(),
              routes: [
                // Detalle de producto (se apila sobre la lista)
                GoRoute(
                  path: 'detalle/:id',
                  builder: (context, state) {
                    final id = state.pathParameters['id']!;
                    return ProductoDetalleScreen(productoId: id);
                  },
                ),
              ],
            ),
          ],
        ),

        // TAB 1: Carrito
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/carrito',
              builder: (context, state) => const CarritoScreen(),
            ),
          ],
        ),

        // TAB 2: Pedidos
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/pedidos',
              builder: (context, state) => const PedidosListScreen(),
            ),
          ],
        ),

        // TAB 3: Perfil
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/perfil',
              builder: (context, state) => const PerfilScreen(),
              routes: [
                // Editar perfil (se apila sobre la vista de perfil)
                GoRoute(
                  path: 'editar',
                  builder: (context, state) => const EditarPerfilScreen(),
                ),
              ],
            ),
          ],
        ),
      ],
    ),

    // Ruta Checkout (fuera del shell de tabs)
    GoRoute(
      path: '/checkout',
      builder: (context, state) => const CheckoutScreen(),
    ),

    // Ruta Pagos (fuera del shell de tabs)
    GoRoute(
      path: '/pagos/:ventaId',
      builder: (context, state) {
        final ventaId = int.parse(state.pathParameters['ventaId']!);
        final extra = state.extra as Map<String, dynamic>;
        final totalRaw = extra['total'];
        final total =
            (totalRaw is int) ? totalRaw.toDouble() : totalRaw as double;

        return PagoScreen(ventaId: ventaId, total: total);
      },
    ),

    // Ruta Detalle de Pedido (fuera del shell de tabs)
    GoRoute(
      path: '/pedidos/detalle/:id',
      builder: (context, state) {
        final pedidoId = state.pathParameters['id']!;
        return PedidoDetalleScreen(pedidoId: pedidoId);
      },
    ),

    // Ruta Login (fuera del shell de tabs)
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),

    // Ruta Register (fuera del shell de tabs)
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
  ],
);
