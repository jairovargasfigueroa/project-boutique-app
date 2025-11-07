import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/producto_detalle_provider.dart';
import '../providers/variantes_provider.dart';
import '../../../carrito/presentation/providers/carrito_provider.dart';

class ProductoDetalleScreen extends StatefulWidget {
  final String productoId;

  const ProductoDetalleScreen({Key? key, required this.productoId})
    : super(key: key);

  @override
  State<ProductoDetalleScreen> createState() => _ProductoDetalleScreenState();
}

class _ProductoDetalleScreenState extends State<ProductoDetalleScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final productoId = int.parse(widget.productoId);

      // Cargar producto individual
      context.read<ProductoDetalleProvider>().cargarProducto(productoId);

      // Cargar variantes
      context.read<VariantesProvider>().cargarVariantes(productoId);
    });
  }

  @override
  void dispose() {
    // Limpiar al salir
    context.read<ProductoDetalleProvider>().limpiar();
    context.read<VariantesProvider>().limpiar();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle del Producto')),
      body: Consumer2<ProductoDetalleProvider, VariantesProvider>(
        builder: (context, productoProvider, variantesProvider, child) {
          // Si está cargando el producto
          if (productoProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Si hay error al cargar producto
          if (productoProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: ${productoProvider.error}',
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      final productoId = int.parse(widget.productoId);
                      productoProvider.cargarProducto(productoId);
                    },
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          // Si no hay producto
          if (productoProvider.producto == null) {
            return const Center(child: Text('Producto no encontrado'));
          }

          final producto = productoProvider.producto!;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Información del producto
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        producto.nombre,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(producto.descripcion),
                      const SizedBox(height: 8),
                      Text(
                        'Precio Base: \$${producto.precioBase}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      if (producto.marca != null) ...[
                        const SizedBox(height: 8),
                        Text('Marca: ${producto.marca}'),
                      ],
                      if (producto.genero != null) ...[
                        const SizedBox(height: 4),
                        Text('Género: ${producto.genero}'),
                      ],
                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 16),
                      Text(
                        'Variantes Disponibles:',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                ),

                // Variantes
                if (variantesProvider.isLoading)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: CircularProgressIndicator(),
                    ),
                  )
                else if (variantesProvider.error != null)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Error al cargar variantes: ${variantesProvider.error}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  )
                else if (variantesProvider.variantes.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Text('No hay variantes disponibles'),
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: variantesProvider.variantes.length,
                    itemBuilder: (context, index) {
                      final variante = variantesProvider.variantes[index];

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.grey[300],
                            child: Text(
                              variante.talla,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text('${variante.color} - ${variante.talla}'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Precio: \$${variante.precioVenta}'),
                              Text(
                                'Stock: ${variante.stock}',
                                style: TextStyle(
                                  color:
                                      variante.esBajoStock
                                          ? Colors.orange
                                          : Colors.green,
                                ),
                              ),
                            ],
                          ),
                          trailing: ElevatedButton(
                            onPressed:
                                variante.tieneStock
                                    ? () {
                                      // Agregar al carrito
                                      context
                                          .read<CarritoProvider>()
                                          .agregarVariante(variante);

                                      // Mostrar confirmación
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            '✅ ${variante.color} - ${variante.talla} agregado al carrito',
                                          ),
                                          duration: const Duration(seconds: 2),
                                          action: SnackBarAction(
                                            label: 'Ver Carrito',
                                            onPressed: () {
                                              context.go('/carrito');
                                            },
                                          ),
                                        ),
                                      );
                                    }
                                    : null,
                            child: const Text('Agregar'),
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
