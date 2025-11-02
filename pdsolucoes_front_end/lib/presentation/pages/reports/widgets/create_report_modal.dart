import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdsolucoes_front_end/core/constants/app_colors.dart';
import 'package:pdsolucoes_front_end/core/constants/app_typography.dart';
import 'package:pdsolucoes_front_end/presentation/widgets/modals/app_modal.dart';
import 'package:pdsolucoes_front_end/presentation/widgets/inputs/app_text_field.dart';
import 'package:pdsolucoes_front_end/presentation/widgets/inputs/app_text_area.dart';
import 'package:pdsolucoes_front_end/presentation/widgets/inputs/app_date_field.dart';
import 'package:pdsolucoes_front_end/presentation/widgets/buttons/app_button.dart';
import 'package:pdsolucoes_front_end/presentation/widgets/alerts/app_alert.dart';
import 'package:pdsolucoes_front_end/presentation/widgets/alerts/app_error_banner.dart';
import 'package:pdsolucoes_front_end/presentation/blocs/report/report_bloc.dart';
import 'package:pdsolucoes_front_end/presentation/blocs/report/report_event.dart';
import 'package:pdsolucoes_front_end/presentation/blocs/report/report_state.dart';
import 'package:pdsolucoes_front_end/presentation/blocs/employee/employee_bloc.dart';
import 'package:pdsolucoes_front_end/presentation/blocs/employee/employee_event.dart';
import 'package:pdsolucoes_front_end/presentation/blocs/employee/employee_state.dart';

class CreateReportModal extends StatefulWidget {
  const CreateReportModal({Key? key}) : super(key: key);

  static Future<bool?> show(BuildContext context) {
    return AppModal.show<bool>(
      context: context,
      child: const CreateReportModal(),
    );
  }

  @override
  State<CreateReportModal> createState() => _CreateReportModalState();
}

class _CreateReportModalState extends State<CreateReportModal> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _hoursController = TextEditingController();
  DateTime? _selectedDate;
  String? _selectedEmployeeId;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final employeeBloc = context.findAncestorWidgetOfExactType<BlocProvider<EmployeeBloc>>();
      if (employeeBloc != null) {
        context.read<EmployeeBloc>().add(LoadEmployeesEvent(isInitialLoad: true));
      }
    });
  }

  void _handleSubmit() {
    if (_descriptionController.text.isEmpty) {
      AppAlert.warning(context, 'Digite a descrição do report');
      return;
    }

    if (_hoursController.text.isEmpty) {
      AppAlert.warning(context, 'Digite a quantidade de horas');
      return;
    }

    if (_selectedDate == null) {
      AppAlert.warning(context, 'Selecione a data');
      return;
    }

    if (_selectedEmployeeId == null) {
      AppAlert.warning(context, 'Selecione um employee');
      return;
    }

    final hours = int.tryParse(_hoursController.text);
    if (hours == null || hours <= 0) {
      AppAlert.warning(context, 'Digite um número válido de horas');
      return;
    }

    context.read<ReportBloc>().add(
          CreateReportEvent(
            description: _descriptionController.text,
            date: _selectedDate!,
            hours: hours,
            employeeId: _selectedEmployeeId!,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ReportBloc, ReportState>(
      listener: (context, state) {
        if (state is ReportCreated) {
          AppAlert.success(context, 'Report criado com sucesso!');
          Navigator.of(context).pop(true);
        } else if (state is ReportError) {
          setState(() {
            _errorMessage = state.message;
          });
        }
      },
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Criar Report',
              style: AppTypography.h2(color: AppColors.black),
            ),
            const SizedBox(height: 24),
            if (_errorMessage != null) ...[
              AppErrorBanner(
                message: _errorMessage!,
                onDismiss: () {
                  setState(() {
                    _errorMessage = null;
                  });
                },
              ),
              const SizedBox(height: 24),
            ],
            BlocBuilder<ReportBloc, ReportState>(
              builder: (context, reportState) {
                final isLoading = reportState is ReportCreating;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppTextField(
                      label: 'Descrição',
                      placeholder: 'Digite a descrição do report',
                      controller: _descriptionController,
                      enabled: !isLoading,
                    ),
                    const SizedBox(height: 20),
                    AppDateField(
                      label: 'Data',
                      placeholder: 'Selecione a data',
                      initialDate: _selectedDate,
                      enabled: !isLoading,
                      onChanged: (date) {
                        setState(() {
                          _selectedDate = date;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    AppTextField(
                      label: 'Horas',
                      placeholder: 'Digite a quantidade de horas',
                      controller: _hoursController,
                      keyboardType: TextInputType.number,
                      enabled: !isLoading,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                    ),
                    const SizedBox(height: 20),
                    BlocBuilder<EmployeeBloc, EmployeeState>(
                      builder: (context, employeeState) {
                        if (employeeState is EmployeeLoading) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.blue,
                            ),
                          );
                        }

                        if (employeeState is EmployeeLoaded) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'EMPLOYEE',
                                style: AppTypography.label(color: AppColors.gray4),
                              ),
                              const SizedBox(height: 8),
                              DropdownButtonFormField<String>(
                                value: _selectedEmployeeId,
                                decoration: InputDecoration(
                                  hintText: 'Selecione um employee',
                                  hintStyle: AppTypography.paragraph(
                                    color: AppColors.gray3,
                                  ),
                                  filled: true,
                                  fillColor: AppColors.white,
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
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                ),
                                items: employeeState.employees
                                    .map((employee) => DropdownMenuItem(
                                          value: employee.id,
                                          child: Text(
                                            employee.name,
                                            style: AppTypography.paragraph(
                                              color: AppColors.black,
                                            ),
                                          ),
                                        ))
                                    .toList(),
                                onChanged: isLoading
                                    ? null
                                    : (value) {
                                        setState(() {
                                          _selectedEmployeeId = value;
                                        });
                                      },
                              ),
                            ],
                          );
                        }

                        return const SizedBox.shrink();
                      },
                    ),
                    const SizedBox(height: 32),
                    AppButton(
                      text: 'Criar Report',
                      onPressed: isLoading ? null : _handleSubmit,
                      isLoading: isLoading,
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _hoursController.dispose();
    super.dispose();
  }
}

