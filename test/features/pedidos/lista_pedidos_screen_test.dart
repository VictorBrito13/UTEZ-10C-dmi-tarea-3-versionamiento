// IA: bloque generado con opencode y revisado por el alumno.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_cafeteria/features/pedidos/data/pedido_repositorio_falso.dart';
import 'package:gestor_cafeteria/features/pedidos/ui/lista_pedidos_screen.dart';

void main() {
  testWidgets('pasa de cargando a error y luego a lista al reintentar', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ListaPedidosScreen(repositorio: PedidoRepositorioFalso()),
      ),
    );
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Cargando pedidos...'), findsOneWidget);

    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
    expect(find.text('Reintentar'), findsOneWidget);
    expect(find.textContaining('Exception'), findsNothing);
    expect(find.textContaining('Null check'), findsNothing);

    await tester.tap(find.text('Reintentar'));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
    expect(find.text('Pedido P-1001'), findsOneWidget);
    expect(find.text('Pedido P-1005'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });
}
