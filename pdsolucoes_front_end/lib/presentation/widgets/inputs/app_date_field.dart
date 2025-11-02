import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdsolucoes_front_end/core/constants/app_colors.dart';
import 'package:pdsolucoes_front_end/core/constants/app_typography.dart';

class AppDateField extends StatefulWidget {
  final String? label;
  final String? placeholder;
  final String? errorText;
  final String? helperText;
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final ValueChanged<DateTime?>? onChanged;
  final bool enabled;

  const AppDateField({
    Key? key,
    this.label,
    this.placeholder,
    this.errorText,
    this.helperText,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.onChanged,
    this.enabled = true,
  }) : super(key: key);

  @override
  State<AppDateField> createState() => _AppDateFieldState();
}

class _AppDateFieldState extends State<AppDateField> {
  DateTime? _selectedDate;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    _updateController();
  }

  @override
  void didUpdateWidget(AppDateField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialDate != oldWidget.initialDate) {
      _selectedDate = widget.initialDate;
      _updateController();
    }
  }

  void _updateController() {
    if (_selectedDate != null) {
      _controller.text = DateFormat('dd/MM/yyyy').format(_selectedDate!);
    } else {
      _controller.text = '';
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    if (!widget.enabled) return;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: widget.firstDate ?? DateTime(1900),
      lastDate: widget.lastDate ?? DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.blue,
              onPrimary: AppColors.white,
              surface: AppColors.white,
              onSurface: AppColors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _updateController();
      });
      widget.onChanged?.call(_selectedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool hasValue = _selectedDate != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!.toUpperCase(),
            style: AppTypography.label(color: AppColors.gray4),
          ),
          const SizedBox(height: 6),
        ],
        TextFormField(
          controller: _controller,
          readOnly: true,
          enabled: widget.enabled,
          onTap: () => _selectDate(context),
          style: AppTypography.paragraph(
            color: hasValue ? AppColors.black : AppColors.gray3,
          ),
          decoration: InputDecoration(
            hintText: widget.placeholder ?? 'dd/mm/aaaa',
            errorText: widget.errorText,
            helperText: widget.helperText,
            prefixIcon: Icon(
              Icons.calendar_today,
              color: hasValue ? AppColors.blue : AppColors.gray3,
              size: 20,
            ),
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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

