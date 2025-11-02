import 'package:flutter/material.dart';
import 'package:pdsolucoes_front_end/core/constants/app_colors.dart';
import 'package:pdsolucoes_front_end/core/constants/app_typography.dart';
import 'package:pdsolucoes_front_end/domain/entities/squad_entity.dart';

class SquadHoursDetailModal extends StatelessWidget {
  final SquadEntity squad;

  const SquadHoursDetailModal({
    Key? key,
    required this.squad,
  }) : super(key: key);

  static void show(BuildContext context, SquadEntity squad) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: SquadHoursDetailModal(squad: squad),
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
                backgroundColor: AppColors.blue.withOpacity(0.1),
                radius: 24,
                child: const Icon(Icons.groups, color: AppColors.blue, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      squad.name,
                      style: AppTypography.h4(color: AppColors.black),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Detalhes de Horas',
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
            'Total de Horas',
            '0h',
            Icons.access_time,
            AppColors.blue,
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            'Média de Horas/Dia',
            '0h',
            Icons.trending_up,
            AppColors.green,
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            'Total de Membros',
            '0',
            Icons.people,
            AppColors.purple,
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            'Horas Estimadas',
            '0h',
            Icons.schedule,
            AppColors.warning,
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

