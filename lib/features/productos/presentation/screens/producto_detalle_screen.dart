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
                // Imagen del producto
                if (producto.imagenUrl.isNotEmpty)
                  Image.network(
                    producto.imagenUrl,
                    height: 300,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 300,
                        color: Colors.grey[300],
                        child: const Icon(Icons.image_not_supported, size: 80),
                      );
                    },
                  ),

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
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Chip(
                            label: Text(producto.categoriaNombre),
                            backgroundColor: Colors.blue[100],
                          ),
                          const SizedBox(width: 8),
                          Chip(
                            label: Text(producto.genero),
                            backgroundColor: Colors.purple[100],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Stock disponible: ${producto.stock}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: producto.stock > 0 ? Colors.green : Colors.red,
                        ),
                      ),
                      if (producto.marca != null) ...[
                        const SizedBox(height: 8),
                        Text('Marca: ${producto.marca}'),
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
                          leading:
                              variante.talla != null
                                  ? CircleAvatar(
                                    backgroundColor: Colors.blue[100],
                                    child: Text(
                                      variante.talla!,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )
                                  : CircleAvatar(
                                    backgroundColor: Colors.grey[300],
                                    child: const Icon(Icons.inventory_2),
                                  ),
                          title: Text(
                            variante.talla != null
                                ? 'Talla: ${variante.talla}'
                                : variante.productoNombre,
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Precio: \$${variante.precio}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(
                                    variante.hayStock
                                        ? Icons.check_circle
                                        : Icons.cancel,
                                    size: 16,
                                    color:
                                        variante.hayStock
                                            ? Colors.green
                                            : Colors.red,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Stock: ${variante.stock}',
                                    style: TextStyle(
                                      color:
                                          variante.stockBajo
                                              ? Colors.orange
                                              : (variante.hayStock
                                                  ? Colors.green
                                                  : Colors.red),
                                      fontWeight:
                                          variante.stockBajo
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                    ),
                                  ),
                                  if (variante.stockBajo && variante.hayStock)
                                    Container(
                                      margin: const EdgeInsets.only(left: 8),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.orange,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: const Text(
                                        '¡Últimas unidades!',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                ],
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
                                            variante.talla != null
                                                ? '✅ ${variante.productoNombre} (${variante.talla}) agregado al carrito'
                                                : '✅ ${variante.productoNombre} agregado al carrito',
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
