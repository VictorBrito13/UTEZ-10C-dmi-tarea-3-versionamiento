# Declaración de uso de IA · Tarea 3 de nivelación

## Herramienta

opencode (asistente de IA en la terminal, modelo DeepSeek) usado como
herramienta declarada de Nivel 2 para generar y revisar código.

## Prompts principales

1. «Implementa la rama `feat/lista-tres-estados` con `Resultado<T>`, la entidad
   `Pedido`, un repositorio falso que falle la primera llamada y una pantalla
   `StatefulWidget` con `switch` exhaustivo, estados de carga, lista y error con
   reintento. Usa solo `setState` y revisa `mounted` después de cada `await`.»
2. «Agrega un widget test que recorra cargando → error → reintento → lista y
   genere capturas PNG de los tres estados con una fuente real.»
3. «Redacta esta declaración con las marcas `// IA:` del código y una guía corta
   para la defensa oral.»

## Qué acepté

- La estructura de archivos: `lib/core/resultado.dart`,
  `lib/features/pedidos/{domain,data,ui}`.
- La jerarquía `Resultado<T>` con `Cargando`, `Exito` y `Error`.
- El repositorio falso con `Future.delayed` de 2 s, cinco pedidos y fallo en la
  primera llamada.
- La pantalla con `switch` exhaustivo, `ListView.builder` de `Card` y el botón
  `Reintentar`.
- El widget test funcional y la herramienta `tool/capturar_estados_test.dart`
  que genera las evidencias.

## Qué cambié o rechacé

- Rechacé `Provider`, `Bloc` y `Riverpod`: la tarea pide solo `StatefulWidget` y
  `setState`.
- Rechacé mostrar el texto crudo de la excepción en la pantalla de error; el
  mensaje quedó en español y legible («Revisa tu conexión e inténtalo de
  nuevo.»), sin `Exception` ni stack trace.
- Ajusté el mensaje para no repetir el título del estado de error.
- Separé la prueba funcional (portable, sin archivos) de la herramienta que
  genera las capturas, para que `flutter test` no dependa de rutas de fuentes
  del sistema.
- Revisé y ejecuté todo el código; las marcas `// IA:` indican los bloques
  generados con la herramienta.

## Cómo lo probé

- `flutter analyze`: sin errores ni advertencias.
- `flutter test`: 16 pruebas en verde (15 anteriores + la nueva de la pantalla).
- `flutter test tool/capturar_estados_test.dart`: recorre los tres estados y el
  reintento, y genera `docs/evidencias/01-cargando.png`,
  `02-error.png` y `03-lista.png`.
- `flutter build web --release`: compila correctamente.
- Evidencia adicional: `docs/evidencias/estados.gif` con la secuencia.

## Marcas `// IA:`

- `lib/core/resultado.dart`
- `lib/features/pedidos/domain/pedido.dart`
- `lib/features/pedidos/data/pedido_repositorio_falso.dart`
- `lib/features/pedidos/ui/lista_pedidos_screen.dart` (incluye el `switch` y
  los `mounted`)
- `lib/main.dart`
- `test/features/pedidos/lista_pedidos_screen_test.dart`
- `tool/capturar_estados_test.dart`

## Para la defensa oral

- **`switch` sin `default`:** `Resultado` es `sealed`; el compilador conoce sus
  tres subclases y obliga a cubrirlas. Si mañana se agrega un estado nuevo, el
  código no compila hasta atenderlo.
- **`mounted`:** después de un `await`, la pantalla pudo cerrarse. `mounted`
  indica si el `State` sigue en el árbol; si es `false`, no se llama a
  `setState`.
- **`setState` → `build`:** `setState` marca el `State` como sucio y programa un
  nuevo `build`; por eso el `switch` se vuelve a evaluar y cambia la pantalla.
- **Repositorio falso:** `_llamadas` cuenta las peticiones; la primera lanza una
  excepción y la segunda devuelve los cinco pedidos, lo que permite probar el
  error y el reintento.
- **`Cargando` en el reintento:** el botón llama a `_cargar()`, que primero
  vuelve a `Cargando` y después intenta otra vez.
