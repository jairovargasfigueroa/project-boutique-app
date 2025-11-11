import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../carrito/presentation/providers/carrito_provider.dart';
import '../providers/checkout_provider.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final carritoProvider = context.watch<CarritoProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Confirmar Compra')),
      body: Column(
        children: [
          // Resumen de items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text(
                  'Resumen de tu compra',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                // Lista de items
                ...carritoProvider.items.map((item) {
                  return Card(
                    child: ListTile(
                      title: Text(item.variante.productoNombre),
                      subtitle: Text(
                        item.variante.talla != null
                            ? 'Talla: ${item.variante.talla} - Cantidad: ${item.cantidad}'
                            : 'Cantidad: ${item.cantidad}',
                      ),
                      trailing: Text(
                        '\$${item.subtotal.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  );
                }),

                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),

                // Tipo de pago
                Card(
                  color: Colors.blue[50],
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Tipo de Pago',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Contado',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.blue[900],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Total
                Card(
                  color: Colors.green[50],
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total a Pagar:',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '\$${carritoProvider.total}',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[900],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Botón confirmar
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SafeArea(
              child: Consumer<CheckoutProvider>(
                builder: (context, checkoutProvider, child) {
                  return SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton.icon(
                      onPressed:
                          checkoutProvider.isLoading
                              ? null
                              : () async {
                                // Preparar datos de venta
                                final ventaData = carritoProvider.prepararVenta(
                                  tipoVenta: 'contado',
                                );

                                // Guardar total antes de limpiar carrito
                                final total = carritoProvider.total.toDouble();

                                // Crear venta
                                await checkoutProvider.crearVenta(ventaData);

                                if (checkoutProvider.error == null) {
                                  // Éxito
                                  final ventaId =
                                      checkoutProvider.ventaCreada!['id'];

                                  // Limpiar carrito
                                  carritoProvider.limpiar();

                                  if (context.mounted) {
                                    // Navegar a pantalla de pago
                                    context.push(
                                      '/pagos/$ventaId',
                                      extra: {
                                        'ventaId': ventaId,
                                        'total': total,
                                      },
                                    );
                                  }
                                } else {
                                  // Error
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          '❌ ${checkoutProvider.error}',
                                        ),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                }
                              },
                      icon:
                          checkoutProvider.isLoading
                              ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                              : const Icon(Icons.check_circle, size: 24),
                      label: Text(
                        checkoutProvider.isLoading
                            ? 'Procesando...'
                            : 'Confirmar Compra',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
