// lib/features/perfil/presentation/screens/perfil_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/perfil_provider.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  @override
  void initState() {
    super.initState();
    // Cargar perfil solo si está autenticado
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = context.read<AuthProvider>();
      if (authProvider.isAuthenticated) {
        context.read<PerfilProvider>().cargarPerfil();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              if (authProvider.isAuthenticated) {
                return IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    context.push('/perfil/editar');
                  },
                  tooltip: 'Editar Perfil',
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          // Si NO está autenticado, mostrar botones de login/register
          if (!authProvider.isAuthenticated) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.person_outline,
                      size: 100,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Inicia sesión para ver tu perfil',
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          context.push('/login');
                        },
                        icon: const Icon(Icons.login),
                        label: const Text('Iniciar Sesión'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          context.push('/register');
                        },
                        icon: const Icon(Icons.person_add),
                        label: const Text('Registrarse'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.all(16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          // Si está autenticado, mostrar el perfil
          return Consumer<PerfilProvider>(
            builder: (context, perfilProvider, child) {
              // Loading
              if (perfilProvider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              // Error
              if (perfilProvider.errorMessage != null) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.red,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Error al cargar perfil',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(perfilProvider.errorMessage!),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () {
                          perfilProvider.cargarPerfil();
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text('Reintentar'),
                      ),
                    ],
                  ),
                );
              }

              // Sin datos
              if (!perfilProvider.tienePerfil) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.person_outline,
                        size: 100,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No se encontró perfil',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                );
              }

              // Mostrar perfil
              final perfil = perfilProvider.perfil!;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Avatar
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      child: Text(
                        (perfil.firstName != null &&
                                perfil.firstName!.isNotEmpty)
                            ? perfil.firstName![0].toUpperCase()
                            : perfil.username[0].toUpperCase(),
                        style: const TextStyle(
                          fontSize: 48,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Nombre completo
                    Text(
                      perfil.nombreCompleto,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 8),

                    // Username
                    Text(
                      '@${perfil.username}',
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),

                    const SizedBox(height: 32),

                    // Card de información
                    Card(
                      elevation: 2,
                      child: Column(
                        children: [
                          // Email
                          ListTile(
                            leading: const Icon(
                              Icons.email,
                              color: Colors.blue,
                            ),
                            title: const Text('Email'),
                            subtitle: Text(perfil.email),
                          ),
                          const Divider(height: 1),

                          // Username
                          ListTile(
                            leading: const Icon(
                              Icons.person,
                              color: Colors.green,
                            ),
                            title: const Text('Usuario'),
                            subtitle: Text(perfil.username),
                          ),
                          const Divider(height: 1),

                          // Nombre
                          ListTile(
                            leading: const Icon(
                              Icons.badge,
                              color: Colors.orange,
                            ),
                            title: const Text('Nombre'),
                            subtitle: Text(
                              (perfil.firstName != null &&
                                      perfil.firstName!.isNotEmpty)
                                  ? perfil.firstName!
                                  : 'No especificado',
                            ),
                          ),
                          const Divider(height: 1),

                          // Apellido
                          ListTile(
                            leading: const Icon(
                              Icons.badge_outlined,
                              color: Colors.purple,
                            ),
                            title: const Text('Apellido'),
                            subtitle: Text(
                              (perfil.lastName != null &&
                                      perfil.lastName!.isNotEmpty)
                                  ? perfil.lastName!
                                  : 'No especificado',
                            ),
                          ),
                          const Divider(height: 1),

                          // Rol
                          ListTile(
                            leading: const Icon(
                              Icons.admin_panel_settings,
                              color: Colors.deepPurple,
                            ),
                            title: const Text('Rol'),
                            subtitle: Text(
                              (perfil.rol != null && perfil.rol!.isNotEmpty)
                                  ? perfil.rol!
                                  : 'No especificado',
                            ),
                          ),
                          const Divider(height: 1),

                          // Teléfono
                          ListTile(
                            leading: const Icon(
                              Icons.phone,
                              color: Colors.teal,
                            ),
                            title: const Text('Teléfono'),
                            subtitle: Text(
                              (perfil.telefono != null &&
                                      perfil.telefono!.isNotEmpty)
                                  ? perfil.telefono!
                                  : 'No especificado',
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Botón Editar Perfil (alternativo)
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          context.push('/perfil/editar');
                        },
                        icon: const Icon(Icons.edit),
                        label: const Text('Editar Perfil'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.all(16),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Botón Cerrar Sesión
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          await context.read<AuthProvider>().logout();
                          if (context.mounted) {
                            context.go('/productos');
                          }
                        },
                        icon: const Icon(Icons.logout),
                        label: const Text('Cerrar Sesión'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.all(16),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
