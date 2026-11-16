// IA: bloque generado con opencode y revisado por el alumno.
class Pedido {
  const Pedido({
    required this.folio,
    required this.cliente,
    required this.producto,
    required this.cantidad,
    required this.total,
  });

  final String folio;
  final String cliente;
  final String producto;
  final int cantidad;
  final double total;
}
