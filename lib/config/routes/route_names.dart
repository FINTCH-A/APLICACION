class RouteNames {
  // Auth
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';

  // Main
  static const String home = '/';
  static const String splash = '/splash';

  // Solicitudes
  static const String solicitudes = '/solicitudes';
  static const String nuevaSolicitud = '/solicitudes/nueva';
  static const String detalleSolicitud = '/solicitudes/detalle/:id';

  // Préstamos
  static const String prestamos = '/prestamos';
  static const String detallePrestamo = '/prestamos/detalle/:id';

  // Pagos
  static const String pagos = '/pagos';
  static const String registrarPago = '/pagos/registrar/:id';
  static const String nuevaPago = '/pagos/nueva';

  // Perfil
  static const String perfil = '/perfil';
  static const String editarPerfil = '/perfil/editar';

  // Helpers
  static String detalleSolicitudPath(String id) => '/solicitudes/detalle/$id';
  static String detallePrestamoPath(String id) => '/prestamos/detalle/$id';
  static String registrarPagoPath(String id) => '/pagos/registrar/$id';

  // Nuevo helper para pagar desde cuota
  static String nuevaPagoPath({
    required int loanId,
    required int installmentId,
  }) {
    return '/pagos/nueva?loanId=$loanId&installmentId=$installmentId';
  }
}
