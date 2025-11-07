import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/productos_provider.dart';
import '../widgets/producto_card.dart';

class ProductosListScreen extends StatefulWidget {
  const ProductosListScreen({Key? key}) : super(key: key);

  @override
  State<ProductosListScreen> createState() => _ProductosListScreenState();
}

class _ProductosListScreenState extends State<ProductosListScreen> {
  @override
  void initState() {
    super.initState();
    // Cargar productos al iniciar la pantalla
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductosProvider>().cargarProductos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos'),
      ),
      body: Consumer<ProductosProvider>(
        builder: (context, productosProvider, child) {
          if (productosProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (productosProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: ${productosProvider.error}',
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => productosProvider.cargarProductos(),
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          if (productosProvider.productos.isEmpty) {
            return const Center(
              child: Text('No hay productos disponibles'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: productosProvider.productos.length,
            itemBuilder: (context, index) {
              final producto = productosProvider.productos[index];
              return ProductoCard(producto: producto);
            },
          );
        },
      ),
    );
  }
}