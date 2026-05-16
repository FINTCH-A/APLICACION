// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../config/theme/app_colors.dart';
import '../../../config/theme/text_styles.dart';
import '../../../config/routes/route_names.dart';
import '../../../data/providers/prestamo_provider.dart';
import '../../../data/models/solicitud_model.dart';
import '../../widgets/common/empty_state.dart';
import '../../widgets/common/error_widget.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/cards/solicitud_card.dart';

class SolicitudesScreen extends StatefulWidget {
  const SolicitudesScreen({super.key});

  @override
  State<SolicitudesScreen> createState() => _SolicitudesScreenState();
}

class _SolicitudesScreenState extends State<SolicitudesScreen> {
  @override
  void initState() {
    super.initState();
    _loadSolicitudes();
  }

  Future<void> _loadSolicitudes() async {
    final provider = context.read<PrestamoProvider>();
    await provider.loadLoanApplications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Solicitudes'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              context.push(RouteNames.nuevaSolicitud);
            },
            tooltip: 'Nueva Solicitud',
          ),
        ],
      ),
      body: Consumer<PrestamoProvider>(
        builder: (context, provider, child) {
          if (provider.isLoadingApplications) {
            return const LoadingWidget();
          }

          if (provider.applicationsError != null) {
            return ErrorWidgetCustom(
              message: provider.applicationsError!,
              onRetry: _loadSolicitudes,
            );
          }

          final solicitudes = provider.loanApplications;

          if (solicitudes.isEmpty) {
            return EmptyState(
              title: 'No tienes solicitudes',
              message: 'Realiza tu primera solicitud de préstamo',
              icon: Icons.receipt_outlined,
              buttonText: 'Nueva Solicitud',
              onButtonPressed: () {
                context.push(RouteNames.nuevaSolicitud);
              },
            );
          }

          return RefreshIndicator(
            onRefresh: _loadSolicitudes,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: solicitudes.length,
              itemBuilder: (context, index) {
                final solicitud = solicitudes[index];
                return SolicitudCard(
                  solicitud: solicitud,
                  onTap: () {
                    context.push(
                      RouteNames.detalleSolicitudPath(solicitud.id.toString()),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push(RouteNames.nuevaSolicitud);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
