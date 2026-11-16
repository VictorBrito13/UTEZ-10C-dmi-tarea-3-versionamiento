# gestor_cafeteria

Cliente Flutter para los pedidos de una cafetería. Consume la API de `mini_backend`, traduce las respuestas HTTP a fallos tipados (`Failure`) y prueba el cliente con `MockClient`, sin depender de la red.

## Requisitos

- Flutter 3.47 o superior (Dart `^3.13.2`).
- Node.js 22.13 o superior para el servidor.
- Un emulador de Android, Chrome o un dispositivo físico para ejecutar la app.

## Servidor: mini_backend

El servidor es otro repositorio y **no** se copia dentro de este proyecto:

<https://github.com/DMI-2026/mini_backend>

Versión con la que se probó: commit `94d2533` (2026-10-08, rama `master`).

```bash
git clone https://github.com/DMI-2026/mini_backend.git
cd mini_backend
node server.js          # http://localhost:8000
```

No requiere `npm install`. Comprueba que responde con:

```bash
curl http://localhost:8000/health   # {"status":"ok"}
```

## Ejecutar la app

```bash
flutter pub get
flutter run -d chrome
```

- **Android Emulator:** usa automáticamente `http://10.0.2.2:8000`.
- **Chrome:** usa `http://localhost:8000`.
- **Dispositivo físico:** indica la IP de tu computadora y usa la misma red:

```bash
flutter run --dart-define=API_URL=http://192.168.1.10:8000
```

También puedes fijar la URL con la variable `API_URL` al compilar o ejecutar.

## Pruebas y análisis

```bash
flutter test       # 15 pruebas: fallos + ApiClient con MockClient
flutter analyze    # sin errores ni advertencias
```

## Estructura

```text
lib/
  core/
    failure.dart        # jerarquía sellada de fallos de la app
    http_client.dart    # ApiClient: baseUrl, timeout y mapeo HTTP -> Failure
  main.dart             # punto de entrada y pantalla de prueba
test/
  core/
    failure_test.dart
    http_client_test.dart
```

## Estado

- Mapeo de `404`, `409`, `422`, `5xx` y códigos no contemplados a `Failure`.
- `3xx` se considera respuesta no exitosa.
- Métodos disponibles: `get`, `post`, `patch` y `delete`.
- Pruebas aisladas con `package:http/testing.dart`; ninguna usa la red.
