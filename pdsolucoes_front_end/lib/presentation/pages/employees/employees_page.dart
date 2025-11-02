import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdsolucoes_front_end/core/constants/app_colors.dart';
import 'package:pdsolucoes_front_end/core/constants/app_typography.dart';
import 'package:pdsolucoes_front_end/presentation/widgets/empty_state/app_empty_state.dart';
import 'package:pdsolucoes_front_end/presentation/widgets/modals/app_modal.dart';
import 'package:pdsolucoes_front_end/presentation/widgets/tables/app_data_table.dart';
import 'package:pdsolucoes_front_end/presentation/widgets/buttons/app_button.dart';
import 'package:pdsolucoes_front_end/presentation/widgets/inputs/app_text_field.dart';
import 'package:pdsolucoes_front_end/presentation/pages/employees/widgets/create_employee_modal.dart';
import 'package:pdsolucoes_front_end/presentation/pages/employees/widgets/view_employee_modal.dart';
import 'package:pdsolucoes_front_end/presentation/blocs/employee/employee_bloc.dart';
import 'package:pdsolucoes_front_end/presentation/blocs/employee/employee_event.dart';
import 'package:pdsolucoes_front_end/presentation/blocs/employee/employee_state.dart';
import 'package:pdsolucoes_front_end/presentation/blocs/squad/squad_bloc.dart';
import 'package:pdsolucoes_front_end/data/datasources/employee_remote_datasource.dart';
import 'package:pdsolucoes_front_end/data/repositories/employee_repository_impl.dart';
import 'package:pdsolucoes_front_end/domain/usecases/get_all_employees_usecase.dart';
import 'package:pdsolucoes_front_end/domain/usecases/create_employee_usecase.dart';

class EmployeesPage extends StatefulWidget {
  const EmployeesPage({Key? key}) : super(key: key);

  @override
  State<EmployeesPage> createState() => _EmployeesPageState();
}

class _EmployeesPageState extends State<EmployeesPage> {
  final _searchController = TextEditingController();
  Timer? _debounce;
  BuildContext? _blocContext;

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    if (_blocContext == null) return;
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _blocContext!.read<EmployeeBloc>().add(LoadEmployeesEvent(search: value.isEmpty ? null : value));
    });
  }

  void _onSearchPressed() {
    if (_blocContext == null) return;
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _blocContext!.read<EmployeeBloc>().add(
      LoadEmployeesEvent(search: _searchController.text.isEmpty ? null : _searchController.text),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (buildContext) {
        final dataSource = EmployeeRemoteDataSource();
        final repository = EmployeeRepositoryImpl(dataSource);
        final bloc = EmployeeBloc(
          getAllEmployeesUseCase: GetAllEmployeesUseCase(repository),
          createEmployeeUseCase: CreateEmployeeUseCase(repository),
        );
        bloc.add(LoadEmployeesEvent(isInitialLoad: true));
        return bloc;
      },
      child: Builder(
        builder: (blocContext) {
          _blocContext = blocContext;
          return _EmployeesPageContent(
            searchController: _searchController,
            onSearchChanged: _onSearchChanged,
            onSearchPressed: _onSearchPressed,
            onCreatePressed: _showCreateEmployeeModal,
            blocContext: blocContext,
          );
        },
      ),
    );
  }
  
  void _showCreateEmployeeModal(BuildContext parentContext) {
    final employeeBloc = parentContext.read<EmployeeBloc>();
    final squadBloc = parentContext.read<SquadBloc>();
    
    showDialog(
      context: parentContext,
      builder: (dialogContext) => Material(
        color: Colors.transparent,
        child: BlocProvider.value(
          value: squadBloc,
          child: BlocProvider.value(
            value: employeeBloc,
            child: AppModal(
              child: const CreateEmployeeModal(),
            ),
          ),
        ),
      ),
    );
  }
}

class _EmployeesPageContent extends StatelessWidget {
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onSearchPressed;
  final Function(BuildContext) onCreatePressed;
  final BuildContext blocContext;

  const _EmployeesPageContent({
    Key? key,
    required this.searchController,
    required this.onSearchChanged,
    required this.onSearchPressed,
    required this.onCreatePressed,
    required this.blocContext,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Funcionários', style: AppTypography.h4()),
        backgroundColor: AppColors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
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

          if (state is EmployeeSearching || state is EmployeeLoaded) {
            final employees = state is EmployeeLoaded 
                ? state.employees 
                : (state as EmployeeSearching).currentEmployees;
            
            // Verifica se há uma busca ativa
            final isSearching = searchController.text.isNotEmpty;

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
                          children: [
                            Expanded(
                              child: AppTextField(
                                placeholder: 'Buscar funcionário por nome...',
                                controller: searchController,
                                onChanged: onSearchChanged,
                                prefixIcon: const Icon(
                                  Icons.search,
                                  color: AppColors.gray4,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            AppButton(
                              text: 'Buscar',
                              onPressed: onSearchPressed,
                              width: 120,
                            ),
                            const SizedBox(width: 12),
                            AppButton(
                              text: 'Criar Funcionário',
                              onPressed: () => onCreatePressed(blocContext),
                              width: 180,
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        // Área da tabela
                        if (employees.isEmpty)
                          Expanded(
                            child: _buildEmptyState(isSearching, blocContext),
                          )
                        else
                          AppDataTable(
                            headers: const ['ID', 'Nome', 'Horas Estimadas', 'Squad'],
                            rows: employees
                                .asMap()
                                .entries
                                .map((entry) => [
                                      (entry.key + 1).toString(),
                                      entry.value.name,
                                      '${entry.value.estimatedHours}h',
                                      entry.value.squadName ?? '-',
                                    ])
                                .toList(),
                            actions: List.generate(
                              employees.length,
                              (index) => (i) {
                                ViewEmployeeModal.show(context, employees[i]);
                              },
                            ),
                            actionLabels: List.generate(
                              employees.length,
                              (index) => 'Ver detalhes',
                            ),
                          ),
                      ],
                    ),
                  );
                }

                // Mobile layout
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: AppTextField(
                                  placeholder: 'Buscar funcionário por nome...',
                                  controller: searchController,
                                  onChanged: onSearchChanged,
                                  prefixIcon: const Icon(
                                    Icons.search,
                                    color: AppColors.gray4,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              AppButton(
                                text: 'Buscar',
                                onPressed: onSearchPressed,
                                width: 120,
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              AppButton(
                                text: 'Criar Funcionário',
                                onPressed: () => onCreatePressed(blocContext),
                                width: 180,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Área da lista
                    Expanded(
                      child: employees.isEmpty
                          ? _buildEmptyState(isSearching, blocContext)
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              itemCount: employees.length,
                              itemBuilder: (context, index) {
                                final employee = employees[index];
                                return Card(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  child: ListTile(
                                    title: Text(
                                      employee.name,
                                      style: AppTypography.paragraph(color: AppColors.black),
                                    ),
                                    subtitle: Text(
                                      '${employee.estimatedHours}h - ${employee.squadName ?? 'Squad'}',
                                      style: AppTypography.small(color: AppColors.gray4),
                                    ),
                                    trailing: const Icon(Icons.chevron_right, color: AppColors.gray4),
                                    onTap: () => ViewEmployeeModal.show(context, employee),
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
            message: 'Nenhum funcionário cadastrado. Crie um funcionário para começar.',
            buttonText: 'Criar Funcionário',
            onPressed: () => onCreatePressed(blocContext),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(bool isSearching, BuildContext blocContext) {
    if (isSearching) {
      // Mensagem de busca sem resultados
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.search_off,
                size: 64,
                color: AppColors.gray4,
              ),
              const SizedBox(height: 16),
              Text(
                'Nenhum resultado encontrado',
                style: AppTypography.h5(color: AppColors.gray1),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Tente buscar com outros termos',
                style: AppTypography.paragraph(color: AppColors.gray4),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }
    
    // Estado vazio original
    return Center(
      child: AppEmptyState(
        message: 'Nenhum funcionário cadastrado. Crie um funcionário para começar.',
        buttonText: 'Criar Funcionário',
        onPressed: () => onCreatePressed(blocContext),
      ),
    );
  }
}
