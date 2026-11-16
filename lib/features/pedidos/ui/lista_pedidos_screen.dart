// IA: bloque generado con opencode y revisado por el alumno.
import 'package:flutter/material.dart';
import 'package:gestor_cafeteria/core/resultado.dart';

import '../data/pedido_repositorio_falso.dart';
import '../domain/pedido.dart';

class ListaPedidosScreen extends StatefulWidget {
  const ListaPedidosScreen({super.key, this.repositorio});

  final PedidoRepositorioFalso? repositorio;

  @override
  State<ListaPedidosScreen> createState() => _ListaPedidosScreenState();
}

class _ListaPedidosScreenState extends State<ListaPedidosScreen> {
  late final PedidoRepositorioFalso _repositorio;
  Resultado<List<Pedido>> _estado = const Cargando();

  @override
  void initState() {
    super.initState();
    _repositorio = widget.repositorio ?? PedidoRepositorioFalso();
    _cargar(mostrarCargando: false);
  }

  Future<void> _cargar({bool mostrarCargando = true}) async {
    if (mostrarCargando) {
      setState(() => _estado = const Cargando());
    }
    try {
      final pedidos = await _repositorio.obtener();
      if (!mounted) return; // La pantalla pudo cerrarse durante el await.
      setState(() => _estado = Exito(pedidos));
    } catch (_) {
      if (!mounted) return; // No llamar a setState si ya no hay pantalla.
      setState(
        () => _estado = const Error('Revisa tu conexión e inténtalo de nuevo.'),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // IA: switch exhaustivo sobre la sealed class, sin default.
    return Scaffold(
      appBar: AppBar(title: const Text('Pedidos')),
      body: switch (_estado) {
        Cargando() => const _EstadoCargando(),
        Exito(datos: final pedidos) => _ListaPedidos(pedidos: pedidos),
        Error(mensaje: final mensaje) => _EstadoError(
          mensaje: mensaje,
          onReintentar: _cargar,
        ),
      },
    );
  }
}

class _EstadoCargando extends StatelessWidget {
  const _EstadoCargando();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            'Cargando pedidos...',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}

class _ListaPedidos extends StatelessWidget {
  const _ListaPedidos({required this.pedidos});

  final List<Pedido> pedidos;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: pedidos.length,
      itemBuilder: (context, indice) {
        final pedido = pedidos[indice];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            title: Text('Pedido ${pedido.folio}', style: textTheme.titleMedium),
            subtitle: Text(
              '${pedido.cliente} · ${pedido.cantidad} × ${pedido.producto}',
            ),
            trailing: Text(
              '\$${pedido.total.toStringAsFixed(2)}',
              style: textTheme.titleSmall,
            ),
          ),
        );
      },
    );
  }
}

class _EstadoError extends StatelessWidget {
  const _EstadoError({required this.mensaje, required this.onReintentar});

  final String mensaje;
  final Future<void> Function() onReintentar;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'No pudimos cargar los pedidos',
              style: textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(mensaje, textAlign: TextAlign.center),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: onReintentar,
              child: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }
}
