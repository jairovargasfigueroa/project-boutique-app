// lib/features/perfil/presentation/screens/editar_perfil_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../data/models/usuario_perfil_model.dart';
import '../providers/perfil_provider.dart';

class EditarPerfilScreen extends StatefulWidget {
  const EditarPerfilScreen({super.key});

  @override
  State<EditarPerfilScreen> createState() => _EditarPerfilScreenState();
}

class _EditarPerfilScreenState extends State<EditarPerfilScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controladores
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    // Inicializar controladores
    _usernameController = TextEditingController();
    _emailController = TextEditingController();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();

    // Cargar datos actuales
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final perfilProvider = context.read<PerfilProvider>();
      if (perfilProvider.tienePerfil) {
        final perfil = perfilProvider.perfil!;
        _usernameController.text = perfil.username;
        _emailController.text = perfil.email;
        _firstNameController.text = perfil.firstName ?? '';
        _lastNameController.text = perfil.lastName ?? '';
      }
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  Future<void> _guardarCambios() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final perfilProvider = context.read<PerfilProvider>();

      // Crear objeto UsuarioPerfil actualizado
      final perfilActualizado = UsuarioPerfil(
        id: perfilProvider.perfil!.id,
        username: _usernameController.text.trim(),
        email: _emailController.text.trim(),
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        rol: perfilProvider.perfil!.rol,
        telefono: perfilProvider.perfil!.telefono,
      );

      await perfilProvider.actualizarPerfil(perfilActualizado);

      if (mounted) {
        // Mostrar mensaje de éxito
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Perfil actualizado correctamente'),
            backgroundColor: Colors.green,
          ),
        );

        // Volver a la pantalla anterior
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al actualizar perfil: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Perfil'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          // Botón guardar en AppBar
          if (!_isLoading)
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: _guardarCambios,
              tooltip: 'Guardar',
            ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
        ],
      ),
      body: Consumer<PerfilProvider>(
        builder: (context, perfilProvider, child) {
          // Mostrar loading si está cargando inicialmente
          if (perfilProvider.isLoading && !perfilProvider.tienePerfil) {
            return const Center(child: CircularProgressIndicator());
          }

          // Si no hay perfil, mostrar error
          if (!perfilProvider.tienePerfil) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  const Text('No se pudo cargar el perfil'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      perfilProvider.cargarPerfil();
                    },
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          // Formulario de edición
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Avatar (no editable)
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          child: Text(
                            _firstNameController.text.isNotEmpty
                                ? _firstNameController.text[0].toUpperCase()
                                : _usernameController.text.isNotEmpty
                                ? _usernameController.text[0].toUpperCase()
                                : '?',
                            style: const TextStyle(
                              fontSize: 48,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.edit,
                              size: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Username (solo lectura)
                  TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Usuario',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                      enabled: false,
                      helperText: 'El nombre de usuario no se puede modificar',
                    ),
                    enabled: false,
                  ),

                  const SizedBox(height: 16),

                  // Email
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'El email es obligatorio';
                      }
                      // Validación básica de email
                      final emailRegex = RegExp(
                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                      );
                      if (!emailRegex.hasMatch(value.trim())) {
                        return 'Ingresa un email válido';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // Nombre
                  TextFormField(
                    controller: _firstNameController,
                    decoration: const InputDecoration(
                      labelText: 'Nombre',
                      prefixIcon: Icon(Icons.badge),
                      border: OutlineInputBorder(),
                    ),
                    textCapitalization: TextCapitalization.words,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'El nombre es obligatorio';
                      }
                      if (value.trim().length < 2) {
                        return 'El nombre debe tener al menos 2 caracteres';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // Apellido
                  TextFormField(
                    controller: _lastNameController,
                    decoration: const InputDecoration(
                      labelText: 'Apellido',
                      prefixIcon: Icon(Icons.badge_outlined),
                      border: OutlineInputBorder(),
                    ),
                    textCapitalization: TextCapitalization.words,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'El apellido es obligatorio';
                      }
                      if (value.trim().length < 2) {
                        return 'El apellido debe tener al menos 2 caracteres';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 32),

                  // Botón Guardar
                  ElevatedButton.icon(
                    onPressed: _isLoading ? null : _guardarCambios,
                    icon:
                        _isLoading
                            ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                            : const Icon(Icons.save),
                    label: Text(
                      _isLoading ? 'Guardando...' : 'Guardar Cambios',
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Botón Cancelar
                  OutlinedButton.icon(
                    onPressed:
                        _isLoading
                            ? null
                            : () {
                              context.pop();
                            },
                    icon: const Icon(Icons.cancel),
                    label: const Text('Cancelar'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
