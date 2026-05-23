import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'config/theme/app_theme.dart';
import 'config/routes/app_routes.dart';
import 'core/api/api_client.dart';
import 'core/storage/shared_prefs.dart';
import 'data/providers/auth_provider.dart';
import 'data/providers/prestamo_provider.dart';
import 'data/providers/pago_provider.dart';
import 'data/providers/solicitud_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  print('ENV: ${dotenv.env['APP_ENV']}');
  print('API URL: ${dotenv.env['API_URL']}');

  await SharedPrefs.init();
  await ApiClient().init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Providers únicos (eliminados duplicados)
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => PrestamoProvider()),
        ChangeNotifierProvider(create: (_) => PagoProvider()),
        ChangeNotifierProvider(create: (_) => SolicitudProvider()),
      ],
      child: MaterialApp.router(
        title: 'Avante Fintech',
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.dark,
        theme: AppTheme.darkTheme,
        routerConfig: AppRoutes.router,
      ),
    );
  }
}
