import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pdsolucoes_front_end/core/constants/app_colors.dart';
import 'package:pdsolucoes_front_end/core/constants/app_typography.dart';
import 'package:pdsolucoes_front_end/presentation/widgets/buttons/app_button.dart';

class AppEmptyState extends StatelessWidget {
  final String message;
  final String buttonText;
  final VoidCallback onPressed;

  const AppEmptyState({
    Key? key,
    required this.message,
    required this.buttonText,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/no-data/Emoji 5.svg',
            height: 120,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 24),
          Text(
            message,
            style: AppTypography.paragraph(color: AppColors.gray4),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          AppButton.primary(
            text: buttonText,
            onPressed: onPressed,
            width: 200,
          ),
        ],
      ),
    );
  }
}



