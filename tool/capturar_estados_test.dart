// IA: bloque generado con opencode y revisado por el alumno.
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_cafeteria/features/pedidos/data/pedido_repositorio_falso.dart';
import 'package:gestor_cafeteria/features/pedidos/ui/lista_pedidos_screen.dart';

const _claveCaptura = ValueKey('captura-pantalla');

Future<ByteData> _leerFuente(String ruta) async {
  final bytes = await File(ruta).readAsBytes();
  return ByteData.view(bytes.buffer);
}

Future<void> _capturar(WidgetTester tester, String nombre) async {
  final boundary = tester.renderObject<RenderRepaintBoundary>(
    find.byKey(_claveCaptura),
  );
  await tester.runAsync(() async {
    final image = await boundary.toImage(pixelRatio: 2);
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    final directorio = Directory('docs/evidencias')
      ..createSync(recursive: true);
    File('${directorio.path}/$nombre.png')
        .writeAsBytesSync(data!.buffer.asUint8List());
  });
}

void main() {
  setUpAll(() async {
    // Fuente real para que las capturas no salgan con el font de prueba.
    // Las rutas son de Linux; si no existen, el test sigue con el font Ahem.
    const regular = '/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf';
    const bold = '/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf';
    if (File(regular).existsSync() && File(bold).existsSync()) {
      final loader = FontLoader('Roboto')
        ..addFont(_leerFuente(regular))
        ..addFont(_leerFuente(bold));
      await loader.load();
    }
  });

  testWidgets('muestra cargando, error y lista después de reintentar', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(420, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: const Color(0xFF6F4E37),
        ),
        home: RepaintBoundary(
          key: _claveCaptura,
          child: ListaPedidosScreen(repositorio: PedidoRepositorioFalso()),
        ),
      ),
    );

    await tester.pump(const Duration(milliseconds: 300));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Cargando pedidos...'), findsOneWidget);
    await _capturar(tester, '01-cargando');

    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
    expect(find.text('Reintentar'), findsOneWidget);
    expect(find.textContaining('Exception'), findsNothing);
    await _capturar(tester, '02-error');

    await tester.tap(find.text('Reintentar'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
    expect(find.text('Pedido P-1001'), findsOneWidget);
    expect(find.text('Pedido P-1005'), findsOneWidget);
    await _capturar(tester, '03-lista');
  });
}
