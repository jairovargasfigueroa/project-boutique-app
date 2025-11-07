// lib/features/pedidos/presentation/screens/pedidos_list_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/utils/date_formatter.dart';
import '../providers/pedidos_provider.dart';

class PedidosListScreen extends StatefulWidget {
  const PedidosListScreen({super.key});

  @override
  State<PedidosListScreen> createState() => _PedidosListScreenState();
}

class _PedidosListScreenState extends State<PedidosListScreen> {
  @override
  void initState() {
    super.initState();
    // Cargar pedidos al iniciar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PedidosProvider>().cargarVentas();
    });
  }

  Color _getEstadoColor(String estado) {
    switch (estado.toLowerCase()) {
      case 'pagado':
        return Colors.green;
      case 'pendiente':
        return Colors.orange;
      case 'parcial':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData _getEstadoIcon(String estado) {
    switch (estado.toLowerCase()) {
      case 'pagado':
        return Icons.check_circle;
      case 'pendiente':
        return Icons.schedule;
      case 'parcial':
        return Icons.schedule;
      default:
        return Icons.help;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Pedidos'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<PedidosProvider>().cargarVentas();
            },
          ),
        ],
      ),
      body: Consumer<PedidosProvider>(
        builder: (context, pedidosProvider, child) {
          // Loading
          if (pedidosProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Error
          if (pedidosProvider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error al cargar pedidos',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(pedidosProvider.errorMessage!),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      pedidosProvider.cargarVentas();
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          // Empty
          if (!pedidosProvider.tieneVentas) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_bag_outlined,
                    size: 100,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No tienes pedidos',
                    style: Theme.of(
                      context,
                    ).textTheme.titleLarge?.copyWith(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tus compras aparecerán aquí',
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                ],
              ),
            );
          }

          // Lista de pedidos
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: pedidosProvider.ventas.length,
            itemBuilder: (context, index) {
              final venta = pedidosProvider.ventas[index];
              final fechaFormateada = DateFormatter.formatearFecha(venta.fecha);

              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 12),
                child: InkWell(
                  onTap: () {
                    context.push('/pedidos/detalle/${venta.id}');
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header: Número de pedido y estado
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Pedido #${venta.id}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: _getEstadoColor(
                                  venta.estadoPago,
                                ).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    _getEstadoIcon(venta.estadoPago),
                                    size: 16,
                                    color: _getEstadoColor(venta.estadoPago),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    venta.estadoPago.toUpperCase(),
                                    style: TextStyle(
                                      color: _getEstadoColor(venta.estadoPago),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        // Fecha
                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_today,
                              size: 16,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              fechaFormateada,
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        // Tipo de pago
                        Row(
                          children: [
                            const Icon(
                              Icons.payment,
                              size: 16,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              venta.tipoPago.toUpperCase(),
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),

                        const Divider(height: 24),

                        // Total
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              'Bs. ${venta.total}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
