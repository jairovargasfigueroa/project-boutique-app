// lib/features/pedidos/presentation/screens/pedido_detalle_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../data/datasources/pedidos_datasource.dart';
import '../../data/repositories/pedidos_repository_impl.dart';
import '../../data/models/venta_detalle_model.dart';

class PedidoDetalleScreen extends StatefulWidget {
  final String pedidoId;

  const PedidoDetalleScreen({super.key, required this.pedidoId});

  @override
  State<PedidoDetalleScreen> createState() => _PedidoDetalleScreenState();
}

class _PedidoDetalleScreenState extends State<PedidoDetalleScreen> {
  late final PedidosRepositoryImpl _repository;
  VentaDetalle? _ventaDetalle;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _repository = PedidosRepositoryImpl(datasource: PedidosDatasource());
    _cargarDetalle();
  }

  Future<void> _cargarDetalle() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final detalle = await _repository.obtenerVentaDetalle(
        int.parse(widget.pedidoId),
      );
      setState(() {
        _ventaDetalle = detalle;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Color _getEstadoColor(String estado) {
    switch (estado.toLowerCase()) {
      case 'completado':
        return Colors.green;
      case 'pendiente':
        return Colors.orange;
      case 'cancelado':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pedido #${widget.pedidoId}'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _errorMessage != null
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text('Error al cargar detalle'),
                    const SizedBox(height: 8),
                    Text(_errorMessage!),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _cargarDetalle,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reintentar'),
                    ),
                  ],
                ),
              )
              : _ventaDetalle == null
              ? const Center(child: Text('No se encontró el pedido'))
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Card de información general
                    Card(
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Información del Pedido',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Divider(height: 24),

                            // Fecha
                            _buildInfoRow(
                              Icons.calendar_today,
                              'Fecha',
                              DateFormatter.formatearFecha(
                                _ventaDetalle!.fecha,
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Cliente
                            _buildInfoRow(
                              Icons.person,
                              'Cliente',
                              _ventaDetalle!.clienteNombre,
                            ),
                            const SizedBox(height: 12),

                            // Tipo de venta
                            _buildInfoRow(
                              Icons.payment,
                              'Tipo de Venta',
                              _ventaDetalle!.tipoVenta.toUpperCase(),
                            ),
                            const SizedBox(height: 12),

                            // Estado
                            Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  size: 20,
                                  color: Colors.grey[600],
                                ),
                                const SizedBox(width: 12),
                                const Text(
                                  'Estado:',
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _getEstadoColor(
                                      _ventaDetalle!.estado,
                                    ).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    _ventaDetalle!.estado.toUpperCase(),
                                    style: TextStyle(
                                      color: _getEstadoColor(
                                        _ventaDetalle!.estado,
                                      ),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
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
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Bs. ${_ventaDetalle!.total}',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            // Botón de pagar si está pendiente
                            if (_ventaDetalle!.estado == 'pendiente')
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    context.push(
                                      '/pagos/${_ventaDetalle!.id}',
                                      extra: {
                                        'ventaId': _ventaDetalle!.id,
                                        'total': double.parse(
                                          _ventaDetalle!.total,
                                        ),
                                      },
                                    );
                                  },
                                  icon: const Icon(Icons.payment),
                                  label: const Text('Continuar con el Pago'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Título de items
                    const Text(
                      'Productos',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Lista de items
                    ..._ventaDetalle!.detalles.map((item) {
                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Nombre del producto
                              Text(
                                item.nombreProducto,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),

                              // Talla (si existe)
                              if (item.talla != null)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.orange[50],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    'Talla: ${item.talla}',
                                    style: TextStyle(
                                      color: Colors.orange[800],
                                      fontSize: 12,
                                    ),
                                  ),
                                ),

                              const Divider(height: 24),

                              // Detalles de precio
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Cantidad: ${item.cantidad}',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      Text(
                                        'Precio unit.: Bs. ${item.precioUnitario}',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    'Bs. ${item.subTotal}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Text('$label:', style: const TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(width: 8),
        Expanded(child: Text(value, style: TextStyle(color: Colors.grey[700]))),
      ],
    );
  }
}
