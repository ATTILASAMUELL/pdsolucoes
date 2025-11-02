import 'package:flutter/material.dart';
import 'package:pdsolucoes_front_end/core/constants/app_colors.dart';
import 'package:pdsolucoes_front_end/core/constants/app_typography.dart';

class AppErrorBanner extends StatelessWidget {
  final String message;
  final VoidCallback? onDismiss;

  const AppErrorBanner({
    Key? key,
    required this.message,
    this.onDismiss,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.error.withOpacity(0.1),
        border: Border.all(color: AppColors.error, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.warning,
            color: AppColors.error,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: AppTypography.paragraph(
                color: AppColors.error,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (onDismiss != null) ...[
            const SizedBox(width: 12),
            InkWell(
              onTap: onDismiss,
              child: const Icon(
                Icons.close,
                color: AppColors.error,
                size: 18,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

