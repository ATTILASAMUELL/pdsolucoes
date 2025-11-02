import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdsolucoes_front_end/core/constants/app_colors.dart';
import 'package:pdsolucoes_front_end/core/constants/app_typography.dart';
import 'package:pdsolucoes_front_end/presentation/widgets/empty_state/app_empty_state.dart';
import 'package:pdsolucoes_front_end/presentation/widgets/tables/app_data_table.dart';
import 'package:pdsolucoes_front_end/presentation/widgets/buttons/app_button.dart';
import 'package:pdsolucoes_front_end/presentation/widgets/modals/app_modal.dart';
import 'package:pdsolucoes_front_end/presentation/pages/employees/widgets/create_employee_modal.dart';
import 'package:pdsolucoes_front_end/presentation/pages/hours/widgets/employee_hours_detail_modal.dart';
import 'package:pdsolucoes_front_end/presentation/blocs/employee/employee_bloc.dart';
import 'package:pdsolucoes_front_end/presentation/blocs/employee/employee_event.dart';
import 'package:pdsolucoes_front_end/presentation/blocs/employee/employee_state.dart';
import 'package:pdsolucoes_front_end/presentation/blocs/squad/squad_bloc.dart';
import 'package:pdsolucoes_front_end/data/datasources/employee_remote_datasource.dart';
import 'package:pdsolucoes_front_end/data/datasources/squad_remote_datasource.dart';
import 'package:pdsolucoes_front_end/data/repositories/employee_repository_impl.dart';
import 'package:pdsolucoes_front_end/data/repositories/squad_repository_impl.dart';
import 'package:pdsolucoes_front_end/domain/usecases/get_all_employees_usecase.dart';
import 'package:pdsolucoes_front_end/domain/usecases/create_employee_usecase.dart';
import 'package:pdsolucoes_front_end/domain/usecases/get_all_squads_usecase.dart';
import 'package:pdsolucoes_front_end/domain/usecases/create_squad_usecase.dart';
import 'package:pdsolucoes_front_end/presentation/blocs/squad/squad_event.dart';

class EmployeesHoursTab extends StatelessWidget {
  const EmployeesHoursTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            final dataSource = EmployeeRemoteDataSource();
            final repository = EmployeeRepositoryImpl(dataSource);
            final bloc = EmployeeBloc(
              getAllEmployeesUseCase: GetAllEmployeesUseCase(repository),
              createEmployeeUseCase: CreateEmployeeUseCase(repository),
            );
            bloc.add(LoadEmployeesEvent(isInitialLoad: true));
            return bloc;
          },
        ),
        BlocProvider(
          create: (context) {
            final dataSource = SquadRemoteDataSource();
            final repository = SquadRepositoryImpl(dataSource);
            final bloc = SquadBloc(
              getAllSquadsUseCase: GetAllSquadsUseCase(repository),
              createSquadUseCase: CreateSquadUseCase(repository),
            );
            bloc.add(LoadSquadsEvent(isInitialLoad: true));
            return bloc;
          },
        ),
      ],
      child: const _EmployeesHoursContent(),
    );
  }
}

class _EmployeesHoursContent extends StatelessWidget {
  const _EmployeesHoursContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocBuilder<EmployeeBloc, EmployeeState>(
        builder: (context, state) {
          if (state is EmployeeLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.blue),
            );
          }

          if (state is EmployeeError) {
            return Center(
              child: Text(
                state.message,
                style: AppTypography.paragraph(color: AppColors.error),
              ),
            );
          }

          if (state is EmployeeLoaded) {
            if (state.employees.isEmpty) {
              return AppEmptyState(
                message: 'Nenhum funcionário encontrado. Crie um funcionário para começar.',
                buttonText: 'Criar Funcionário',
                onPressed: () => _showCreateEmployeeModal(context),
              );
            }

            return LayoutBuilder(
              builder: (context, constraints) {
                final isWeb = constraints.maxWidth > 600;

                if (isWeb) {
                  return Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            AppButton(
                              text: 'Criar Funcionário',
                              onPressed: () => _showCreateEmployeeModal(context),
                              width: 180,
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        AppDataTable(
                          headers: const ['ID', 'Nome', 'Squad', 'Horas Estimadas', 'Total Trabalhado'],
                          rows: state.employees
                              .asMap()
                              .entries
                              .map((entry) => [
                                    (entry.key + 1).toString(),
                                    entry.value.name,
                                    entry.value.squadName ?? 'Sem squad',
                                    '${entry.value.estimatedHours}h',
                                    '0h',
                                  ])
                              .toList(),
                          actions: List.generate(
                            state.employees.length,
                            (index) => (i) {
                              EmployeeHoursDetailModal.show(context, state.employees[i]);
                            },
                          ),
                          actionLabels: List.generate(
                            state.employees.length,
                            (index) => 'Ver detalhes',
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          AppButton(
                            text: 'Criar Funcionário',
                            onPressed: () => _showCreateEmployeeModal(context),
                            width: 180,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: state.employees.length,
                        itemBuilder: (context, index) {
                          final employee = state.employees[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: InkWell(
                              onTap: () => EmployeeHoursDetailModal.show(context, employee),
                              borderRadius: BorderRadius.circular(8),
                              child: ExpansionTile(
                                leading: CircleAvatar(
                                  backgroundColor: AppColors.purple.withOpacity(0.1),
                                  child: const Icon(Icons.person, color: AppColors.purple),
                                ),
                                title: Text(
                                  employee.name,
                                  style: AppTypography.paragraph(
                                    color: AppColors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                subtitle: Text(
                                  'Clique para ver detalhes de horas',
                                  style: AppTypography.small(color: AppColors.gray4),
                                ),
                                children: [
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _buildInfoRow(
                                        'Horas Estimadas',
                                        '${employee.estimatedHours}h',
                                        Icons.schedule,
                                      ),
                                      const SizedBox(height: 12),
                                      _buildInfoRow(
                                        'Squad',
                                        employee.squadName ?? 'Sem squad',
                                        Icons.groups,
                                      ),
                                      const SizedBox(height: 12),
                                      _buildInfoRow(
                                        'Total Trabalhado',
                                        '0h',
                                        Icons.access_time,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            );
          }

          return AppEmptyState(
            message: 'Nenhum funcionário encontrado.',
            buttonText: 'Criar Funcionário',
            onPressed: () => _showCreateEmployeeModal(context),
          );
        },
      ),
    );
  }

  void _showCreateEmployeeModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => Material(
        color: Colors.transparent,
        child: BlocProvider.value(
          value: context.read<SquadBloc>(),
          child: BlocProvider.value(
            value: context.read<EmployeeBloc>(),
            child: AppModal(
              child: const CreateEmployeeModal(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.purple),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: AppTypography.small(color: AppColors.gray4),
        ),
        Text(
          value,
          style: AppTypography.small(
            color: AppColors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

