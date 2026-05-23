// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/screens/auth/login_screen.dart';
import '../../presentation/screens/auth/register_screen.dart';
import '../../presentation/screens/auth/forgot_password_screen.dart';
import '../../presentation/screens/home/home_screen.dart';
import '../../presentation/screens/solicitudes/solicitudes_screen.dart';
import '../../presentation/screens/solicitudes/nueva_solicitud_screen.dart';
import '../../presentation/screens/solicitudes/detalle_solicitud_screen.dart';
import '../../presentation/screens/prestamos/prestamos_screen.dart';
import '../../presentation/screens/prestamos/detalle_prestamo_screen.dart';
import '../../presentation/screens/pagos/pagos_screen.dart';
import '../../presentation/screens/pagos/registrar_pago_screen.dart';
import '../../presentation/screens/perfil/perfil_screen.dart';
import '../../presentation/screens/perfil/editar_perfil_screen.dart';
import 'route_names.dart';

class AppRoutes {
  static GoRouter router = GoRouter(
    initialLocation: RouteNames.login,
    routes: [
      // Auth
      GoRoute(
        name: 'login',
        path: RouteNames.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        name: 'register',
        path: RouteNames.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        name: 'forgotPassword',
        path: RouteNames.forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),

      // Home
      GoRoute(
        name: 'home',
        path: RouteNames.home,
        builder: (context, state) => const HomeScreen(),
      ),

      // Solicitudes
      GoRoute(
        name: 'solicitudes',
        path: RouteNames.solicitudes,
        builder: (context, state) => const SolicitudesScreen(),
      ),
      GoRoute(
        name: 'nuevaSolicitud',
        path: RouteNames.nuevaSolicitud,
        builder: (context, state) => const NuevaSolicitudScreen(),
      ),
      GoRoute(
        name: 'detalleSolicitud',
        path: RouteNames.detalleSolicitud,
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return DetalleSolicitudScreen(id: id);
        },
      ),

      // Préstamos
      GoRoute(
        name: 'prestamos',
        path: RouteNames.prestamos,
        builder: (context, state) => const PrestamosScreen(),
      ),
      GoRoute(
        name: 'detallePrestamo',
        path: RouteNames.detallePrestamo,
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return DetallePrestamoScreen(id: id);
        },
      ),

      // Pagos
      GoRoute(
        name: 'pagos',
        path: RouteNames.pagos,
        builder: (context, state) => const PagosScreen(),
      ),
      // Ruta para pagar desde cuota (con query parameters)
      GoRoute(
        name: 'nuevaPago',
        path: RouteNames.nuevaPago,
        builder: (context, state) {
          final loanId = state.uri.queryParameters['loanId'];
          final installmentId = state.uri.queryParameters['installmentId'];
          return RegistrarPagoScreen(
            prestamoId: loanId,
            cuotaId: installmentId != null ? int.parse(installmentId) : null,
          );
        },
      ),
      // Ruta legacy para compatibilidad (sin parámetros)
      GoRoute(
        name: 'registrarPago',
        path: RouteNames.registrarPago,
        builder: (context, state) {
          final id = state.pathParameters['id'];
          return RegistrarPagoScreen(prestamoId: id, cuotaId: null);
        },
      ),

      // Perfil
      GoRoute(
        name: 'perfil',
        path: RouteNames.perfil,
        builder: (context, state) => const PerfilScreen(),
      ),
      GoRoute(
        name: 'editarPerfil',
        path: RouteNames.editarPerfil,
        builder: (context, state) => const EditarPerfilScreen(),
      ),
    ],
  );
}
