import 'package:flutter/material.dart';
import 'package:pdsolucoes_front_end/core/constants/app_colors.dart';
import 'package:pdsolucoes_front_end/core/constants/app_typography.dart';

enum AppButtonType {
  primary,
  secondary,
  alternate,
}

class AppButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonType type;
  final bool isLoading;
  final double? width;
  final double? height;

  const AppButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.type = AppButtonType.primary,
    this.isLoading = false,
    this.width = 123,
    this.height = 48,
  }) : super(key: key);

  const AppButton.primary({
    Key? key,
    required String text,
    VoidCallback? onPressed,
    bool isLoading = false,
    double? width = 123,
    double? height = 48,
  }) : this(
          key: key,
          text: text,
          onPressed: onPressed,
          type: AppButtonType.primary,
          isLoading: isLoading,
          width: width,
          height: height,
        );

  const AppButton.secondary({
    Key? key,
    required String text,
    VoidCallback? onPressed,
    bool isLoading = false,
    double? width = 123,
    double? height = 48,
  }) : this(
          key: key,
          text: text,
          onPressed: onPressed,
          type: AppButtonType.secondary,
          isLoading: isLoading,
          width: width,
          height: height,
        );

  const AppButton.alternate({
    Key? key,
    required String text,
    VoidCallback? onPressed,
    bool isLoading = false,
    double? width = 123,
    double? height = 48,
  }) : this(
          key: key,
          text: text,
          onPressed: onPressed,
          type: AppButtonType.alternate,
          isLoading: isLoading,
          width: width,
          height: height,
        );

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = widget.onPressed == null || widget.isLoading;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: ElevatedButton(
          onPressed: isDisabled ? null : widget.onPressed,
          style: _getButtonStyle(isDisabled),
          child: widget.isLoading
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _getTextColor(isDisabled),
                    ),
                  ),
                )
              : Text(
                  widget.text,
                  style: AppTypography.button(
                    color: _getTextColor(isDisabled),
                  ),
                ),
        ),
      ),
    );
  }

  ButtonStyle _getButtonStyle(bool isDisabled) {
    switch (widget.type) {
      case AppButtonType.primary:
        return ElevatedButton.styleFrom(
          backgroundColor: _getPrimaryBackgroundColor(isDisabled),
          foregroundColor: AppColors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        );

      case AppButtonType.secondary:
        return ElevatedButton.styleFrom(
          backgroundColor: _getSecondaryBackgroundColor(isDisabled),
          foregroundColor: AppColors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        );

      case AppButtonType.alternate:
        return ElevatedButton.styleFrom(
          backgroundColor: AppColors.white,
          foregroundColor: _getAlternateTextColor(isDisabled),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
              color: _getAlternateTextColor(isDisabled),
              width: 1,
            ),
          ),
        );
    }
  }

  Color _getPrimaryBackgroundColor(bool isDisabled) {
    if (isDisabled) return AppColors.blueDisabled;
    if (_isHovering) return AppColors.blueHover;
    return AppColors.blue;
  }

  Color _getSecondaryBackgroundColor(bool isDisabled) {
    if (isDisabled) return AppColors.purpleDisabled;
    if (_isHovering) return AppColors.purpleHover;
    return AppColors.purple;
  }

  Color _getAlternateTextColor(bool isDisabled) {
    if (isDisabled) return AppColors.gray3;
    return AppColors.black;
  }

  Color _getTextColor(bool isDisabled) {
    if (widget.type == AppButtonType.alternate) {
      return _getAlternateTextColor(isDisabled);
    }
    return AppColors.white;
  }
}

