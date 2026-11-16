// IA: bloque generado con opencode y revisado por el alumno.
import '../domain/pedido.dart';

/// Repositorio falso: la primera llamada falla para poder probar el error y el
/// reintento; la segunda y las siguientes devuelven los pedidos de ejemplo.
class PedidoRepositorioFalso {
  int _llamadas = 0;

  Future<List<Pedido>> obtener() async {
    await Future.delayed(const Duration(seconds: 2));
    _llamadas++;
    if (_llamadas == 1) {
      throw Exception('Sin conexión');
    }
    return const [
      Pedido(
        folio: 'P-1001',
        cliente: 'Ana',
        producto: 'Latte',
        cantidad: 2,
        total: 130.00,
      ),
      Pedido(
        folio: 'P-1002',
        cliente: 'Luis',
        producto: 'Capuchino',
        cantidad: 1,
        total: 75.00,
      ),
      Pedido(
        folio: 'P-1003',
        cliente: 'Eva',
        producto: 'Espresso',
        cantidad: 3,
        total: 120.00,
      ),
      Pedido(
        folio: 'P-1004',
        cliente: 'Mario',
        producto: 'Mocha',
        cantidad: 1,
        total: 85.00,
      ),
      Pedido(
        folio: 'P-1005',
        cliente: 'Sofía',
        producto: 'Americano',
        cantidad: 2,
        total: 90.00,
      ),
    ];
  }
}
