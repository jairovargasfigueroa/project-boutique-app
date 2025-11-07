import 'package:boutique_app/core/router/app_router.dart';
import 'package:boutique_app/features/productos/data/datasources/productos_datasource.dart';
import 'package:boutique_app/features/productos/data/repositories/productos_repository_impl.dart';
import 'package:boutique_app/features/productos/presentation/providers/productos_provider.dart';
import 'package:boutique_app/features/productos/presentation/providers/producto_detalle_provider.dart';
import 'package:boutique_app/features/productos/presentation/providers/variantes_provider.dart';
import 'package:boutique_app/features/carrito/presentation/providers/carrito_provider.dart';
import 'package:boutique_app/features/compra/data/datasources/ventas_datasource.dart';
import 'package:boutique_app/features/compra/data/repositories/ventas_repository_impl.dart';
import 'package:boutique_app/features/compra/presentation/providers/checkout_provider.dart';
import 'package:boutique_app/features/pagos/data/datasources/pagos_datasource.dart';
import 'package:boutique_app/features/pagos/data/repositories/pagos_repository_impl.dart';
import 'package:boutique_app/features/pagos/presentation/providers/pago_provider.dart';
import 'package:boutique_app/features/pedidos/data/datasources/pedidos_datasource.dart';
import 'package:boutique_app/features/pedidos/data/repositories/pedidos_repository_impl.dart';
import 'package:boutique_app/features/pedidos/presentation/providers/pedidos_provider.dart';
import 'package:boutique_app/features/perfil/data/datasources/perfil_datasource.dart';
import 'package:boutique_app/features/perfil/data/repositories/perfil_repository_impl.dart';
import 'package:boutique_app/features/perfil/presentation/providers/perfil_provider.dart';
import 'package:boutique_app/features/auth/data/datasources/auth_datasource.dart';
import 'package:boutique_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:boutique_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:boutique_app/core/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create:
              (_) => ProductosProvider(
                repository: ProductosRepositoryImpl(
                  datasource: ProductosDatasource(),
                ),
              ),
        ),
        ChangeNotifierProvider(
          create:
              (_) => ProductoDetalleProvider(
                repository: ProductosRepositoryImpl(
                  datasource: ProductosDatasource(),
                ),
              ),
        ),
        ChangeNotifierProvider(
          create:
              (_) => VariantesProvider(
                repository: ProductosRepositoryImpl(
                  datasource: ProductosDatasource(),
                ),
              ),
        ),
        ChangeNotifierProvider(create: (_) => CarritoProvider()),
        ChangeNotifierProvider(
          create:
              (_) => CheckoutProvider(
                repository: VentasRepositoryImpl(
                  datasource: VentasDatasource(),
                ),
              ),
        ),
        ChangeNotifierProvider(
          create:
              (_) => PagoProvider(
                repository: PagosRepositoryImpl(datasource: PagosDatasource()),
              ),
        ),
        ChangeNotifierProvider(
          create:
              (_) => PedidosProvider(
                repository: PedidosRepositoryImpl(
                  datasource: PedidosDatasource(),
                ),
              ),
        ),
        ChangeNotifierProvider(
          create:
              (_) => PerfilProvider(
                repository: PerfilRepositoryImpl(
                  datasource: PerfilDatasource(),
                ),
              ),
        ),
        ChangeNotifierProvider(
          create:
              (_) => AuthProvider(
                repository: AuthRepositoryImpl(datasource: AuthDatasource()),
                storage: StorageService(),
              ),
        ),
      ],
      child: MaterialApp.router(
        title: 'My Boutique App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        routerConfig: appRouter,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
