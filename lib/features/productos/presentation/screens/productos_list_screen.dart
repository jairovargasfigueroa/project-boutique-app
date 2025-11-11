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

  void _mostrarFiltros() {
    final productosProvider = context.read<ProductosProvider>();
    final filtrosActuales = productosProvider.filtrosActivos;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => _FiltrosBottomSheet(filtrosActuales: filtrosActuales),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos'),
        actions: [
          Consumer<ProductosProvider>(
            builder: (context, provider, child) {
              final tieneFiltros = provider.filtrosActivos.isNotEmpty;
              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.filter_list),
                    onPressed: _mostrarFiltros,
                  ),
                  if (tieneFiltros)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 8,
                          minHeight: 8,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      body: Consumer<ProductosProvider>(
        builder: (context, productosProvider, child) {
          if (productosProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
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
            return const Center(child: Text('No hay productos disponibles'));
          }

          return Column(
            children: [
              // Chips de filtros activos
              if (productosProvider.filtrosActivos.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  color: Colors.grey[100],
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ...productosProvider.filtrosActivos.entries.map((entry) {
                        String label = '';
                        if (entry.key == 'genero') {
                          label = 'Género: ${entry.value}';
                        } else if (entry.key == 'categoria') {
                          label = 'Categoría: ${entry.value}';
                        } else if (entry.key == 'marca') {
                          label = 'Marca: ${entry.value}';
                        }
                        return Chip(
                          label: Text(label),
                          onDeleted: () {
                            final nuevosFiltros = Map<String, dynamic>.from(
                              productosProvider.filtrosActivos,
                            );
                            nuevosFiltros.remove(entry.key);
                            if (nuevosFiltros.isEmpty) {
                              productosProvider.limpiarFiltros();
                            } else {
                              productosProvider.aplicarFiltros(nuevosFiltros);
                            }
                          },
                        );
                      }).toList(),
                      ActionChip(
                        label: const Text('Limpiar todo'),
                        onPressed: () => productosProvider.limpiarFiltros(),
                        avatar: const Icon(Icons.clear, size: 18),
                      ),
                    ],
                  ),
                ),
              // Lista de productos
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: productosProvider.productos.length,
                  itemBuilder: (context, index) {
                    final producto = productosProvider.productos[index];
                    return ProductoCard(producto: producto);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _FiltrosBottomSheet extends StatefulWidget {
  final Map<String, dynamic> filtrosActuales;

  const _FiltrosBottomSheet({required this.filtrosActuales});

  @override
  State<_FiltrosBottomSheet> createState() => _FiltrosBottomSheetState();
}

class _FiltrosBottomSheetState extends State<_FiltrosBottomSheet> {
  late Map<String, dynamic> _filtrosTemp;

  @override
  void initState() {
    super.initState();
    _filtrosTemp = Map<String, dynamic>.from(widget.filtrosActuales);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Filtros',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Filtro por Género
          const Text(
            'Género',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              _buildChoiceChip('Hombre', 'genero', 'H'),
              _buildChoiceChip('Mujer', 'genero', 'M'),
              _buildChoiceChip('Unisex', 'genero', 'U'),
            ],
          ),
          const SizedBox(height: 20),

          // Filtro por Marca
          const Text(
            'Marca',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          TextField(
            decoration: const InputDecoration(
              hintText: 'Buscar por marca',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (value) {
              setState(() {
                if (value.isEmpty) {
                  _filtrosTemp.remove('marca');
                } else {
                  _filtrosTemp['marca'] = value;
                }
              });
            },
            controller: TextEditingController(
              text: _filtrosTemp['marca']?.toString() ?? '',
            ),
          ),
          const SizedBox(height: 20),

          // Filtro por Categoría (ID)
          const Text(
            'Categoría',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          TextField(
            decoration: const InputDecoration(
              hintText: 'ID de categoría',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.category),
            ),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                if (value.isEmpty) {
                  _filtrosTemp.remove('categoria');
                } else {
                  _filtrosTemp['categoria'] = int.tryParse(value) ?? value;
                }
              });
            },
            controller: TextEditingController(
              text: _filtrosTemp['categoria']?.toString() ?? '',
            ),
          ),
          const SizedBox(height: 30),

          // Botones de acción
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _filtrosTemp.clear();
                    });
                  },
                  child: const Text('Limpiar'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    context.read<ProductosProvider>().aplicarFiltros(
                      _filtrosTemp,
                    );
                    Navigator.pop(context);
                  },
                  child: const Text('Aplicar'),
                ),
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
        ],
      ),
    );
  }

  Widget _buildChoiceChip(String label, String key, String value) {
    final isSelected = _filtrosTemp[key] == value;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          if (selected) {
            _filtrosTemp[key] = value;
          } else {
            _filtrosTemp.remove(key);
          }
        });
      },
    );
  }
}
