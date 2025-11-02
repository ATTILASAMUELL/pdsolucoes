import 'package:flutter/material.dart';
import 'package:pdsolucoes_front_end/core/constants/app_colors.dart';
import 'package:pdsolucoes_front_end/core/constants/app_typography.dart';

class AppTextArea extends StatelessWidget {
  final String? label;
  final String? placeholder;
  final String? errorText;
  final String? helperText;
  final TextEditingController? controller;
  final int maxLines;
  final int minLines;
  final bool enabled;
  final ValueChanged<String>? onChanged;
  final String? initialValue;
  final int? maxLength;
  final bool showCounter;

  const AppTextArea({
    Key? key,
    this.label,
    this.placeholder,
    this.errorText,
    this.helperText,
    this.controller,
    this.maxLines = 5,
    this.minLines = 3,
    this.enabled = true,
    this.onChanged,
    this.initialValue,
    this.maxLength,
    this.showCounter = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!.toUpperCase(),
            style: AppTypography.label(color: AppColors.gray4),
          ),
          const SizedBox(height: 6),
        ],
        TextFormField(
          controller: controller,
          initialValue: initialValue,
          keyboardType: TextInputType.multiline,
          maxLines: maxLines,
          minLines: minLines,
          maxLength: maxLength,
          enabled: enabled,
          onChanged: onChanged,
          textAlignVertical: TextAlignVertical.top,
          style: AppTypography.paragraph(
            color: enabled ? AppColors.black : AppColors.gray3,
          ),
          decoration: InputDecoration(
            hintText: placeholder ?? 'Exemplo de texto de descrição da tarefa executada.',
            errorText: errorText,
            helperText: helperText,
            counterText: showCounter ? null : '',
            filled: true,
            fillColor: AppColors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: AppColors.gray2,
                width: 1,
              ),
            ),
            
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: AppColors.gray2,
                width: 1,
              ),
            ),
            
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: AppColors.blue,
                width: 2,
              ),
            ),
            
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: AppColors.error,
                width: 1,
              ),
            ),
            
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: AppColors.error,
                width: 2,
              ),
            ),
            
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: AppColors.gray2,
                width: 1,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

