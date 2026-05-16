// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../config/theme/app_colors.dart';
import '../../../config/theme/text_styles.dart';
import '../../../config/routes/route_names.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_utils.dart';
import '../../../data/models/solicitud_model.dart';
import '../../../data/providers/prestamo_provider.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/common/error_widget.dart';
import '../../widgets/badges/estado_badge.dart';

class DetalleSolicitudScreen extends StatefulWidget {
  final String id;
  const DetalleSolicitudScreen({super.key, required this.id});

  @override
  State<DetalleSolicitudScreen> createState() => _DetalleSolicitudScreenState();
}

class _DetalleSolicitudScreenState extends State<DetalleSolicitudScreen> {
  LoanApplicationModel? _solicitud;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadSolicitud();
  }

  Future<void> _loadSolicitud() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final provider = context.read<PrestamoProvider>();
      // Recargar lista para obtener la solicitud actualizada
      await provider.loadLoanApplications();
      final solicitud = provider.loanApplications.firstWhere(
        (s) => s.id.toString() == widget.id,
      );

      setState(() {
        _solicitud = solicitud;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _cancelarSolicitud() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancelar Solicitud'),
        content: const Text(
          '¿Estás seguro de que deseas cancelar esta solicitud?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Sí, Cancelar'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() {
        _isLoading = true;
      });

      final provider = context.read<PrestamoProvider>();
      final success = await provider.cancelLoanApplication(
        int.parse(widget.id),
      );

      setState(() {
        _isLoading = false;
      });

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Solicitud cancelada exitosamente'),
            backgroundColor: AppColors.success,
          ),
        );
        await _loadSolicitud();
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(provider.applicationsError ?? 'Error al cancelar'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: LoadingWidget());
    }

    if (_error != null || _solicitud == null) {
      return Scaffold(
        body: ErrorWidgetCustom(
          message: _error ?? 'No se encontró la solicitud',
          onRetry: _loadSolicitud,
        ),
      );
    }

    final solicitud = _solicitud!;
    final isEditable = solicitud.status == LoanApplicationStatus.draft;
    final isCancellable =
        solicitud.status == LoanApplicationStatus.draft ||
        solicitud.status == LoanApplicationStatus.submitted ||
        solicitud.status == LoanApplicationStatus.underReview;

    return Scaffold(
      appBar: AppBar(
        title: Text('Solicitud #${solicitud.id}'),
        centerTitle: true,
        actions: [
          if (isEditable)
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: () {
                // TODO: Implementar edición
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Estado
            _InfoCard(
              title: 'Estado',
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Estado actual:', style: TextStyles.bodyMedium),
                  EstadoBadge(status: solicitud.status),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Información de la solicitud
            _InfoCard(
              title: 'Información de la Solicitud',
              child: Column(
                children: [
                  _DetailRow(
                    label: 'Monto solicitado',
                    value: formatCurrency(solicitud.requestedAmount),
                  ),
                  const Divider(),
                  _DetailRow(
                    label: 'Plazo',
                    value: '${solicitud.requestedTerm} meses',
                  ),
                  if (solicitud.purpose != null) ...[
                    const Divider(),
                    _DetailRow(label: 'Propósito', value: solicitud.purpose!),
                  ],
                  const Divider(),
                  _DetailRow(
                    label: 'Fecha de creación',
                    value: DateUtilsCustom.formatDateTime(solicitud.createdAt),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Información de revisión (si está revisada)
            if (solicitud.reviewedAt != null) ...[
              _InfoCard(
                title: 'Revisión',
                child: Column(
                  children: [
                    _DetailRow(
                      label: 'Fecha de revisión',
                      value: DateUtilsCustom.formatDateTime(
                        solicitud.reviewedAt!,
                      ),
                    ),
                    if (solicitud.analystNotes != null) ...[
                      const Divider(),
                      _DetailRow(
                        label: 'Comentarios del analista',
                        value: solicitud.analystNotes!,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Timeline de estados
            _InfoCard(
              title: 'Historial',
              child: Column(
                children: [
                  _TimelineItem(
                    isCompleted: true,
                    title: 'Borrador creado',
                    date: solicitud.createdAt,
                  ),
                  _TimelineItem(
                    isCompleted:
                        solicitud.status != LoanApplicationStatus.draft,
                    isActive:
                        solicitud.status == LoanApplicationStatus.submitted,
                    title: 'Enviada a revisión',
                    date: solicitud.status != LoanApplicationStatus.draft
                        ? solicitud.updatedAt
                        : null,
                  ),
                  _TimelineItem(
                    isCompleted:
                        solicitud.status == LoanApplicationStatus.underReview ||
                        solicitud.status == LoanApplicationStatus.approved ||
                        solicitud.status == LoanApplicationStatus.rejected,
                    isActive:
                        solicitud.status == LoanApplicationStatus.underReview,
                    title: 'En revisión',
                    date:
                        solicitud.status == LoanApplicationStatus.underReview ||
                            solicitud.status ==
                                LoanApplicationStatus.approved ||
                            solicitud.status == LoanApplicationStatus.rejected
                        ? solicitud.updatedAt
                        : null,
                  ),
                  _TimelineItem(
                    isCompleted:
                        solicitud.status == LoanApplicationStatus.approved,
                    isActive:
                        solicitud.status == LoanApplicationStatus.approved,
                    title: 'Aprobada',
                    date: solicitud.status == LoanApplicationStatus.approved
                        ? solicitud.reviewedAt
                        : null,
                    isSuccess: true,
                  ),
                  _TimelineItem(
                    isCompleted:
                        solicitud.status == LoanApplicationStatus.rejected,
                    isActive:
                        solicitud.status == LoanApplicationStatus.rejected,
                    title: 'Rechazada',
                    date: solicitud.status == LoanApplicationStatus.rejected
                        ? solicitud.reviewedAt
                        : null,
                    isError: true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Botones de acción
            if (isCancellable &&
                solicitud.status != LoanApplicationStatus.cancelled)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: OutlinedButton(
                  onPressed: _cancelarSolicitud,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                    side: const BorderSide(color: AppColors.error),
                  ),
                  child: const Text('Cancelar Solicitud'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _InfoCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(title, style: TextStyles.titleSmall),
          ),
          const Divider(height: 1),
          Padding(padding: const EdgeInsets.all(16), child: child),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(flex: 3, child: Text(value, style: TextStyles.bodySmall)),
        ],
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final bool isCompleted;
  final bool isActive;
  final String title;
  final DateTime? date;
  final bool isSuccess;
  final bool isError;

  const _TimelineItem({
    required this.isCompleted,
    this.isActive = false,
    required this.title,
    this.date,
    this.isSuccess = false,
    this.isError = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          // Icono
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _getIconColor().withOpacity(0.1),
            ),
            child: Icon(_getIcon(), size: 18, color: _getIconColor()),
          ),
          const SizedBox(width: 12),
          // Contenido
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyles.bodyMedium.copyWith(
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                    color: isActive ? AppColors.primary : AppColors.textPrimary,
                  ),
                ),
                if (date != null)
                  Text(
                    DateUtilsCustom.formatDateTime(date!),
                    style: TextStyles.labelSmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
              ],
            ),
          ),
          if (isCompleted && !isActive)
            Icon(
              Icons.check_circle,
              size: 20,
              color: isSuccess
                  ? AppColors.success
                  : isError
                  ? AppColors.error
                  : AppColors.textSecondary,
            ),
        ],
      ),
    );
  }

  Color _getIconColor() {
    if (isActive) return AppColors.primary;
    if (isSuccess) return AppColors.success;
    if (isError) return AppColors.error;
    if (isCompleted) return AppColors.textSecondary;
    return AppColors.textDisabled;
  }

  IconData _getIcon() {
    if (isActive) return Icons.hourglass_empty;
    if (isSuccess) return Icons.check_circle;
    if (isError) return Icons.cancel;
    if (isCompleted) return Icons.check_circle_outline;
    return Icons.circle_outlined;
  }
}
