import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdsolucoes_front_end/presentation/widgets/modals/app_modal.dart';
import 'package:pdsolucoes_front_end/presentation/widgets/inputs/app_text_field.dart';
import 'package:pdsolucoes_front_end/presentation/widgets/buttons/app_button.dart';
import 'package:pdsolucoes_front_end/presentation/widgets/alerts/app_alert.dart';
import 'package:pdsolucoes_front_end/presentation/widgets/alerts/app_error_banner.dart';
import 'package:pdsolucoes_front_end/core/constants/app_colors.dart';
import 'package:pdsolucoes_front_end/core/constants/app_typography.dart';
import 'package:pdsolucoes_front_end/presentation/blocs/employee/employee_bloc.dart';
import 'package:pdsolucoes_front_end/presentation/blocs/employee/employee_event.dart';
import 'package:pdsolucoes_front_end/presentation/blocs/employee/employee_state.dart';
import 'package:pdsolucoes_front_end/presentation/blocs/squad/squad_bloc.dart';
import 'package:pdsolucoes_front_end/presentation/blocs/squad/squad_event.dart';
import 'package:pdsolucoes_front_end/presentation/blocs/squad/squad_state.dart';

class CreateEmployeeModal extends StatefulWidget {
  const CreateEmployeeModal({Key? key}) : super(key: key);

  static Future<bool?> show(BuildContext context) {
    return AppModal.show<bool>(
      context: context,
      child: const CreateEmployeeModal(),
    );
  }

  @override
  State<CreateEmployeeModal> createState() => _CreateEmployeeModalState();
}

class _CreateEmployeeModalState extends State<CreateEmployeeModal> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _estimatedHoursController = TextEditingController();
  String? _selectedSquadId;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final squadBloc = context.findAncestorWidgetOfExactType<BlocProvider<SquadBloc>>();
      if (squadBloc != null) {
        context.read<SquadBloc>().add(LoadSquadsEvent(isInitialLoad: true));
      }
    });
  }

  void _handleSubmit() {
    if (_nameController.text.isEmpty) {
      AppAlert.warning(context, 'Digite o nome do funcionário');
      return;
    }

    if (_estimatedHoursController.text.isEmpty) {
      AppAlert.warning(context, 'Digite as horas estimadas');
      return;
    }

    final hours = int.tryParse(_estimatedHoursController.text);
    if (hours == null || hours < 1 || hours > 12) {
      AppAlert.warning(context, 'Horas estimadas devem estar entre 1 e 12');
      return;
    }

    if (_selectedSquadId == null) {
      AppAlert.warning(context, 'Selecione uma squad');
      return;
    }

    context.read<EmployeeBloc>().add(
          CreateEmployeeEvent(
            name: _nameController.text,
            estimatedHours: hours,
            squadId: _selectedSquadId!,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EmployeeBloc, EmployeeState>(
      listener: (context, state) {
        if (state is EmployeeCreated) {
          AppAlert.success(context, 'Funcionário criado com sucesso!');
          Navigator.of(context).pop(true);
        } else if (state is EmployeeError) {
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
              'Criar Funcionário(a)',
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
            BlocBuilder<EmployeeBloc, EmployeeState>(
              builder: (context, employeeState) {
                final isLoading = employeeState is EmployeeCreating;
                
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppTextField(
                      label: 'Nome do Funcionário',
                      placeholder: 'Digite o nome do funcionário',
                      controller: _nameController,
                      enabled: !isLoading,
                    ),
                    const SizedBox(height: 24),
                    AppTextField(
                      label: 'Horas Estimadas de Trabalho',
                      placeholder: 'Digite a quantidade de horas (1-12)',
                      controller: _estimatedHoursController,
                      keyboardType: TextInputType.number,
                      enabled: !isLoading,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                    ),
                    const SizedBox(height: 24),
                    BlocBuilder<SquadBloc, SquadState>(
                      builder: (context, squadState) {
                        final squads = squadState is SquadLoaded ? squadState.squads : [];
                        
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'SQUAD',
                              style: AppTypography.label(color: AppColors.gray4),
                            ),
                            const SizedBox(height: 6),
                            DropdownButtonFormField<String>(
                              value: _selectedSquadId,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: AppColors.white,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(color: AppColors.gray2, width: 1),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(color: AppColors.gray2, width: 1),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(color: AppColors.blue, width: 2),
                                ),
                              ),
                              hint: Text(
                                'Selecione uma squad',
                                style: AppTypography.paragraph(color: AppColors.gray3),
                              ),
                              items: squads.map((squad) {
                                return DropdownMenuItem<String>(
                                  value: squad.id,
                                  child: Text(
                                    squad.name,
                                    style: AppTypography.paragraph(color: AppColors.black),
                                  ),
                                );
                              }).toList(),
                              onChanged: isLoading
                                  ? null
                                  : (value) {
                                      setState(() => _selectedSquadId = value);
                                    },
                              style: AppTypography.paragraph(color: AppColors.black),
                              dropdownColor: AppColors.white,
                              icon: const Icon(Icons.arrow_drop_down, color: AppColors.gray4),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 40),
                    AppButton.primary(
                      text: 'Criar Funcionário',
                      onPressed: isLoading ? null : _handleSubmit,
                      isLoading: isLoading,
                      width: double.infinity,
                      height: 56,
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
    _nameController.dispose();
    _estimatedHoursController.dispose();
    super.dispose();
  }
}


