import 'package:flutter/material.dart';
import 'package:pdsolucoes_front_end/core/constants/app_colors.dart';
import 'package:pdsolucoes_front_end/core/constants/app_typography.dart';
import 'package:pdsolucoes_front_end/presentation/widgets/buttons/app_button.dart';
import 'package:pdsolucoes_front_end/presentation/widgets/inputs/app_text_field.dart';
import 'package:pdsolucoes_front_end/presentation/widgets/inputs/app_date_field.dart';
import 'package:pdsolucoes_front_end/presentation/widgets/inputs/app_text_area.dart';

class DesignSystemShowcase extends StatefulWidget {
  const DesignSystemShowcase({Key? key}) : super(key: key);

  @override
  State<DesignSystemShowcase> createState() => _DesignSystemShowcaseState();
}

class _DesignSystemShowcaseState extends State<DesignSystemShowcase> {
  final _textController = TextEditingController();
  final _errorController = TextEditingController(text: 'Error');
  final _successController = TextEditingController(text: 'Success');
  final _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDSoluções - Design System'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              title: 'Colors',
              subtitle: 'Primaries and grays',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Text(
                    'PRIMARY COLORS',
                    style: AppTypography.h5(color: AppColors.gray4),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildColorBox('BLUE', '#4263EB', AppColors.blue),
                      const SizedBox(width: 16),
                      _buildColorBox('PURPLE', '#7048E8', AppColors.purple),
                      const SizedBox(width: 16),
                      _buildColorBox('GREEN', '#51CF66', AppColors.green),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'GRAYSCALE',
                    style: AppTypography.h5(color: AppColors.gray4),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildColorBox('BLACK', '#212429', AppColors.black),
                      const SizedBox(width: 8),
                      _buildColorBox('GRAY 4', '#495057', AppColors.gray4),
                      const SizedBox(width: 8),
                      _buildColorBox('GRAY 3', '#ACB5BD', AppColors.gray3),
                      const SizedBox(width: 8),
                      _buildColorBox('GRAY 2', '#DDE2E5', AppColors.gray2),
                      const SizedBox(width: 8),
                      _buildColorBox('GRAY 1', '#F8F9FA', AppColors.gray1),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 48),

            _buildSection(
              title: 'Typography',
              subtitle: 'Roboto set with the perfect-fourth modular type scale',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Text('Hayes Valley Studio', style: AppTypography.h1()),
                  const SizedBox(height: 4),
                  Text('H1', style: AppTypography.small(color: AppColors.gray4)),
                  const SizedBox(height: 16),
                  Text('Hayes Valley Studio', style: AppTypography.h2()),
                  const SizedBox(height: 4),
                  Text('H2', style: AppTypography.small(color: AppColors.gray4)),
                  const SizedBox(height: 16),
                  Text('Hayes Valley Studio', style: AppTypography.h3()),
                  const SizedBox(height: 4),
                  Text('H3', style: AppTypography.small(color: AppColors.gray4)),
                  const SizedBox(height: 16),
                  Text('Hayes Valley Studio', style: AppTypography.h4()),
                  const SizedBox(height: 4),
                  Text('H4', style: AppTypography.small(color: AppColors.gray4)),
                  const SizedBox(height: 16),
                  Text('HAYES VALLEY STUDIO', style: AppTypography.h5()),
                  const SizedBox(height: 4),
                  Text('H5', style: AppTypography.small(color: AppColors.gray4)),
                  const SizedBox(height: 16),
                  Text('Hayes Valley Studio', style: AppTypography.paragraph()),
                  const SizedBox(height: 4),
                  Text('P', style: AppTypography.small(color: AppColors.gray4)),
                  const SizedBox(height: 16),
                  Text('Hayes Valley Studio', style: AppTypography.small()),
                  const SizedBox(height: 4),
                  Text('SMALL', style: AppTypography.small(color: AppColors.gray4)),
                ],
              ),
            ),

            const SizedBox(height: 48),

            _buildSection(
              title: 'Buttons',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  
                  Text(
                    'DEFAULT',
                    style: AppTypography.h5(color: AppColors.gray4),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      AppButton.primary(
                        text: 'Primary',
                        onPressed: () {},
                      ),
                      AppButton.secondary(
                        text: 'Secondary',
                        onPressed: () {},
                      ),
                      AppButton.alternate(
                        text: 'Alternate',
                        onPressed: () {},
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  Text(
                    'DISABLED',
                    style: AppTypography.h5(color: AppColors.gray4),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: const [
                      AppButton.primary(
                        text: 'Primary',
                        onPressed: null,
                      ),
                      AppButton.secondary(
                        text: 'Secondary',
                        onPressed: null,
                      ),
                      AppButton.alternate(
                        text: 'Alternate',
                        onPressed: null,
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  Text(
                    'LOADING',
                    style: AppTypography.h5(color: AppColors.gray4),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      AppButton.primary(
                        text: 'Primary',
                        isLoading: true,
                        onPressed: () {},
                      ),
                      AppButton.secondary(
                        text: 'Secondary',
                        isLoading: true,
                        onPressed: () {},
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  Text(
                    'WITH ICONS',
                    style: AppTypography.h5(color: AppColors.gray4),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      AppButton.primary(
                        text: 'Save',
                        icon: Icons.save,
                        onPressed: () {},
                      ),
                      AppButton.secondary(
                        text: 'Delete',
                        icon: Icons.delete,
                        onPressed: () {},
                      ),
                      AppButton.alternate(
                        text: 'Cancel',
                        icon: Icons.close,
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 48),

            _buildSection(
              title: 'Forms',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  
                  AppTextField(
                    label: 'Label',
                    placeholder: 'Placeholder',
                    controller: _textController,
                  ),

                  const SizedBox(height: 16),

                  const AppTextField(
                    label: 'Focus',
                    initialValue: 'Filled Input',
                  ),

                  const SizedBox(height: 16),

                  AppTextField(
                    label: 'Success',
                    controller: _successController,
                    showSuccess: true,
                  ),

                  const SizedBox(height: 16),

                  AppTextField(
                    label: 'Error',
                    controller: _errorController,
                    errorText: 'Campo obrigatório',
                  ),

                  const SizedBox(height: 16),

                  AppDateField(
                    label: 'Label',
                    placeholder: '01/02/2022',
                    onChanged: (date) {
                      print('Data selecionada: $date');
                    },
                  ),

                  const SizedBox(height: 16),

                  AppDateField(
                    label: 'Label',
                    initialDate: DateTime(2022, 2, 1),
                    onChanged: (date) {
                      print('Data selecionada: $date');
                    },
                  ),

                  const SizedBox(height: 16),

                  AppTextArea(
                    label: 'Descrição',
                    placeholder: 'Exemplo de texto de descrição da tarefa executada.',
                    controller: _descriptionController,
                    maxLines: 4,
                    minLines: 3,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    String? subtitle,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTypography.h2(color: AppColors.black),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: AppTypography.paragraph(color: AppColors.gray4),
          ),
        ],
        const SizedBox(height: 8),
        const Divider(color: AppColors.gray2, thickness: 1),
        child,
      ],
    );
  }

  Widget _buildColorBox(String label, String hex, Color color) {
    final bool isDark = color.computeLuminance() < 0.5;
    
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 60,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.gray2,
                width: 1,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: AppTypography.small(
              color: AppColors.gray4,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            hex,
            style: AppTypography.small(color: AppColors.gray4),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _errorController.dispose();
    _successController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}

