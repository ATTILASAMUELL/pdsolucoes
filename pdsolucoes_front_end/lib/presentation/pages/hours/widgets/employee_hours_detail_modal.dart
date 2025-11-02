import 'package:flutter/material.dart';
import 'package:pdsolucoes_front_end/core/constants/app_colors.dart';
import 'package:pdsolucoes_front_end/core/constants/app_typography.dart';
import 'package:pdsolucoes_front_end/domain/entities/employee_entity.dart';

class EmployeeHoursDetailModal extends StatelessWidget {
  final EmployeeEntity employee;

  const EmployeeHoursDetailModal({
    Key? key,
    required this.employee,
  }) : super(key: key);

  static void show(BuildContext context, EmployeeEntity employee) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: EmployeeHoursDetailModal(employee: employee),
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
                backgroundColor: AppColors.purple.withOpacity(0.1),
                radius: 24,
                child: const Icon(Icons.person, color: AppColors.purple, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      employee.name,
                      style: AppTypography.h4(color: AppColors.black),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      employee.squadName ?? 'Sem squad',
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
          _buildInfoRow(
            'Horas Estimadas',
            '${employee.estimatedHours}h',
            Icons.schedule,
            AppColors.blue,
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            'Total Trabalhado',
            '0h',
            Icons.access_time,
            AppColors.green,
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            'Horas Restantes',
            '${employee.estimatedHours}h',
            Icons.timer,
            AppColors.warning,
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            'Progresso',
            '0%',
            Icons.trending_up,
            AppColors.purple,
          ),
          const SizedBox(height: 24),
          const Divider(color: AppColors.gray2),
          const SizedBox(height: 16),
          Text(
            'Período de análise: Últimos 7 dias',
            style: AppTypography.small(color: AppColors.gray4),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.1),
            radius: 20,
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTypography.small(color: AppColors.gray4),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: AppTypography.h5(color: color),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

