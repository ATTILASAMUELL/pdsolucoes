import 'package:flutter/material.dart';
import 'package:pdsolucoes_front_end/core/constants/app_colors.dart';
import 'package:pdsolucoes_front_end/core/constants/app_typography.dart';
import 'package:pdsolucoes_front_end/presentation/widgets/modals/app_modal.dart';
import 'package:pdsolucoes_front_end/domain/entities/employee_entity.dart';

class ViewEmployeeModal extends StatelessWidget {
  final EmployeeEntity employee;

  const ViewEmployeeModal({
    Key? key,
    required this.employee,
  }) : super(key: key);

  static Future<void> show(BuildContext context, EmployeeEntity employee) {
    return showDialog(
      context: context,
      builder: (dialogContext) => Material(
        color: Colors.transparent,
        child: AppModal(
          child: ViewEmployeeModal(employee: employee),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Detalhes do Funcionário',
          style: AppTypography.h2(color: AppColors.black),
        ),
        const SizedBox(height: 32),
        _buildInfoRow('Nome', employee.name),
        const SizedBox(height: 24),
        _buildInfoRow('Horas Estimadas', '${employee.estimatedHours}h'),
        const SizedBox(height: 24),
        _buildInfoRow('Squad', employee.squadName ?? 'Sem squad'),
        const SizedBox(height: 24),
        _buildInfoRow('ID', employee.id),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: AppTypography.label(color: AppColors.gray4),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.gray1,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.gray2, width: 1),
          ),
          child: Text(
            value,
            style: AppTypography.paragraph(color: AppColors.black),
          ),
        ),
      ],
    );
  }
}

