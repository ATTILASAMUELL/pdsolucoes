import 'package:flutter/material.dart';
import 'package:pdsolucoes_front_end/core/constants/app_colors.dart';
import 'package:pdsolucoes_front_end/core/constants/app_typography.dart';
import 'package:pdsolucoes_front_end/domain/entities/report_entity.dart';
import 'package:intl/intl.dart';

class ReportHoursDetailModal extends StatelessWidget {
  final ReportEntity report;

  const ReportHoursDetailModal({
    Key? key,
    required this.report,
  }) : super(key: key);

  static void show(BuildContext context, ReportEntity report) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: ReportHoursDetailModal(report: report),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 600),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.green.withOpacity(0.1),
                radius: 24,
                child: const Icon(Icons.assignment, color: AppColors.green, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Detalhes do Relatório',
                      style: AppTypography.h4(color: AppColors.black),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('dd/MM/yyyy HH:mm').format(report.createdAt),
                      style: AppTypography.small(color: AppColors.gray4),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
                color: AppColors.gray4,
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Divider(color: AppColors.gray2),
          const SizedBox(height: 24),
          _buildInfoSection('Descrição', report.description, Icons.description),
          const SizedBox(height: 16),
          _buildInfoSection('Funcionário', report.employeeName, Icons.person),
          const SizedBox(height: 16),
          _buildInfoSection('Squad', report.squadName, Icons.groups),
          const SizedBox(height: 16),
          _buildHoursCard('${report.hours}h'),
          const SizedBox(height: 24),
          const Divider(color: AppColors.gray2),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Criado em',
                style: AppTypography.small(color: AppColors.gray4),
              ),
              Text(
                DateFormat('dd/MM/yyyy HH:mm').format(report.createdAt),
                style: AppTypography.small(
                  color: AppColors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.gray4),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTypography.small(color: AppColors.gray4),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: AppTypography.paragraph(
                color: AppColors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHoursCard(String hours) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.green.withOpacity(0.1),
            AppColors.green.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.green.withOpacity(0.3), width: 2),
      ),
      child: Column(
        children: [
          const Icon(Icons.access_time, color: AppColors.green, size: 32),
          const SizedBox(height: 8),
          Text(
            'Horas Trabalhadas',
            style: AppTypography.small(color: AppColors.gray4),
          ),
          const SizedBox(height: 8),
          Text(
            hours,
            style: AppTypography.h2(color: AppColors.green),
          ),
        ],
      ),
    );
  }
}

