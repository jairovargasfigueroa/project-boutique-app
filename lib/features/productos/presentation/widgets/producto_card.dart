import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/producto_model.dart';

class ProductoCard extends StatelessWidget {
  final ProductoModel producto;

  const ProductoCard({Key? key, required this.producto}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          context.push('/productos/detalle/${producto.id}');
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                producto.nombre,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                producto.descripcion,
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '\$${producto.precioBase}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  if (producto.genero != null)
                    Chip(
                      label: Text(producto.genero!),
                      backgroundColor: Colors.blue[100],
                    ),
                ],
              ),
              if (producto.marca != null) ...[
                const SizedBox(height: 8),
                Text(
                  'Marca: ${producto.marca}',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
              if (producto.categoria != null) ...[
                const SizedBox(height: 4),
                Text(
                  'Categoría: ${producto.categoria!.nombre}',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
