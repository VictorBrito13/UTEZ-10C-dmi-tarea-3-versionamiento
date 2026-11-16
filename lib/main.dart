// IA: bloque generado con opencode y revisado por el alumno.
import 'package:flutter/material.dart';

import 'features/pedidos/ui/lista_pedidos_screen.dart';

void main() {
  runApp(const GestorCafeteriaApp());
}

class GestorCafeteriaApp extends StatelessWidget {
  const GestorCafeteriaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestor Cafetería',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF6F4E37),
      ),
      home: const ListaPedidosScreen(),
    );
  }
}
