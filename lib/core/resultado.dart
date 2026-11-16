// IA: bloque generado con opencode y revisado por el alumno.
// Estados posibles de una carga de datos: cargando, con datos o con error.
sealed class Resultado<T> {
  const Resultado();
}

final class Cargando<T> extends Resultado<T> {
  const Cargando();
}

final class Exito<T> extends Resultado<T> {
  const Exito(this.datos);
  final T datos;
}

final class Error<T> extends Resultado<T> {
  const Error(this.mensaje);
  final String mensaje;
}
