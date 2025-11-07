// lib/features/pagos/presentation/screens/pago_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../data/models/pago_request_model.dart';
import '../providers/pago_provider.dart';

class PagoScreen extends StatefulWidget {
  final int ventaId;
  final double total;

  const PagoScreen({super.key, required this.ventaId, required this.total});

  @override
  State<PagoScreen> createState() => _PagoScreenState();
}

class _PagoScreenState extends State<PagoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _referenciaController = TextEditingController();

  String _metodoPagoSeleccionado = 'efectivo';

  final List<Map<String, String>> _metodosPago = [
    {'value': 'efectivo', 'label': '💵 Efectivo'},
    {'value': 'qr', 'label': '📱 QR'},
    {'value': 'tarjeta', 'label': '💳 Tarjeta'},
  ];

  @override
  void dispose() {
    _referenciaController.dispose();
    super.dispose();
  }

  Future<void> _confirmarPago() async {
    if (!_formKey.currentState!.validate()) return;

    final pagoProvider = context.read<PagoProvider>();

    final pago = PagoRequest(
      venta: widget.ventaId,
      montoPagado: widget.total,
      metodoPago: _metodoPagoSeleccionado,
      referenciaPago: _referenciaController.text.trim(),
    );

    final exito = await pagoProvider.crearPago(pago);

    if (!mounted) return;

    if (exito) {
      // Mostrar confirmación y redirigir
      _mostrarConfirmacion();
    } else {
      // Mostrar error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(pagoProvider.errorMessage ?? 'Error al procesar pago'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _mostrarConfirmacion() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            icon: const Icon(Icons.check_circle, color: Colors.green, size: 64),
            title: const Text('¡Pago Exitoso!'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Venta #${widget.ventaId}'),
                const SizedBox(height: 8),
                Text(
                  'Bs. ${widget.total.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Redirigiendo a tus pedidos...'),
              ],
            ),
          ),
    );

    // Auto-redirect después de 3 segundos
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      Navigator.of(context).pop(); // Cerrar diálogo
      context.go('/carrito'); // Ir a pedidos (cuando esté implementado)
      // TODO: Cambiar a context.go('/pedidos') cuando implementes la pantalla
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Procesar Pago'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Consumer<PagoProvider>(
        builder: (context, pagoProvider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Resumen de Venta
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const Text(
                            'Resumen de Compra',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Divider(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Venta #'),
                              Text(
                                '${widget.ventaId}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total a Pagar:',
                                style: TextStyle(fontSize: 18),
                              ),
                              Text(
                                'Bs. ${widget.total.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 24,
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

                  const SizedBox(height: 24),

                  // Método de Pago
                  const Text(
                    'Método de Pago',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _metodoPagoSeleccionado,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.payment),
                    ),
                    items:
                        _metodosPago.map((metodo) {
                          return DropdownMenuItem(
                            value: metodo['value'],
                            child: Text(metodo['label']!),
                          );
                        }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _metodoPagoSeleccionado = value!;
                      });
                    },
                  ),

                  const SizedBox(height: 24),

                  // Referencia de Pago
                  const Text(
                    'Referencia de Pago',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _referenciaController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Ej: Pago inicial, Transf. banco ABC, etc.',
                      prefixIcon: Icon(Icons.note),
                    ),
                    maxLines: 2,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Ingresa una referencia de pago';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 32),

                  // Botón Confirmar Pago
                  SizedBox(
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: pagoProvider.isLoading ? null : _confirmarPago,
                      icon:
                          pagoProvider.isLoading
                              ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                              : const Icon(Icons.check_circle, size: 28),
                      label: Text(
                        pagoProvider.isLoading
                            ? 'Procesando...'
                            : 'Confirmar Pago',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),

                  if (pagoProvider.errorMessage != null) ...[
                    const SizedBox(height: 16),
                    Card(
                      color: Colors.red.shade50,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            const Icon(Icons.error, color: Colors.red),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                pagoProvider.errorMessage!,
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
