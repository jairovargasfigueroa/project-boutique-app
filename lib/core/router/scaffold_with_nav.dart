// lib/core/router/scaffold_with_nav.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';

class ScaffoldWithNavBar extends StatelessWidget {
  const ScaffoldWithNavBar({Key? key, required this.navigationShell})
    : super(key: key);

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            if (authProvider.isAuthenticated && authProvider.user != null) {
              return Row(
                children: [
                  const Icon(Icons.person, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Hola, ${authProvider.user!.username}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              );
            } else {
              return Row(
                children: [
                  const Icon(Icons.person_outline, size: 20),
                  const SizedBox(width: 8),
                  const Text('Invitado', style: TextStyle(fontSize: 16)),
                ],
              );
            }
          },
        ),
        actions: [
          Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              if (!authProvider.isAuthenticated) {
                return TextButton.icon(
                  onPressed: () {
                    context.push('/login');
                  },
                  icon: const Icon(Icons.login, color: Colors.white),
                  label: const Text(
                    'Iniciar sesión',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: navigationShell.currentIndex,
        onTap: (index) => navigationShell.goBranch(index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined),
            activeIcon: Icon(Icons.shopping_bag),
            label: 'Productos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            activeIcon: Icon(Icons.shopping_cart),
            label: 'Carrito',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            activeIcon: Icon(Icons.receipt_long),
            label: 'Pedidos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
