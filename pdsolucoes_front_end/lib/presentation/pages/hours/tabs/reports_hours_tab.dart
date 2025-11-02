import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdsolucoes_front_end/core/constants/app_colors.dart';
import 'package:pdsolucoes_front_end/core/constants/app_typography.dart';
import 'package:pdsolucoes_front_end/presentation/widgets/empty_state/app_empty_state.dart';
import 'package:pdsolucoes_front_end/presentation/widgets/modals/app_modal.dart';
import 'package:pdsolucoes_front_end/presentation/widgets/tables/app_data_table.dart';
import 'package:pdsolucoes_front_end/presentation/widgets/buttons/app_button.dart';
import 'package:pdsolucoes_front_end/presentation/widgets/alerts/app_alert.dart';
import 'package:pdsolucoes_front_end/presentation/pages/reports/widgets/create_report_modal.dart';
import 'package:pdsolucoes_front_end/presentation/pages/hours/widgets/report_hours_detail_modal.dart';
import 'package:pdsolucoes_front_end/presentation/blocs/report/report_bloc.dart';
import 'package:pdsolucoes_front_end/presentation/blocs/report/report_event.dart';
import 'package:pdsolucoes_front_end/presentation/blocs/report/report_state.dart';
import 'package:pdsolucoes_front_end/presentation/blocs/employee/employee_bloc.dart';
import 'package:pdsolucoes_front_end/data/datasources/report_remote_datasource.dart';
import 'package:pdsolucoes_front_end/data/datasources/employee_remote_datasource.dart';
import 'package:pdsolucoes_front_end/data/repositories/report_repository_impl.dart';
import 'package:pdsolucoes_front_end/data/repositories/employee_repository_impl.dart';
import 'package:pdsolucoes_front_end/domain/usecases/create_report_usecase.dart';
import 'package:pdsolucoes_front_end/domain/usecases/get_dashboard_usecase.dart';
import 'package:pdsolucoes_front_end/domain/usecases/get_all_reports_usecase.dart';
import 'package:pdsolucoes_front_end/domain/usecases/get_all_employees_usecase.dart';
import 'package:pdsolucoes_front_end/domain/usecases/create_employee_usecase.dart';
import 'package:pdsolucoes_front_end/presentation/blocs/employee/employee_event.dart';
import 'package:intl/intl.dart';

class ReportsHoursTab extends StatelessWidget {
  const ReportsHoursTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
      create: (context) {
        final dataSource = ReportRemoteDataSource();
        final repository = ReportRepositoryImpl(dataSource);
        final bloc = ReportBloc(
          createReportUseCase: CreateReportUseCase(repository),
          getDashboardUseCase: GetDashboardUseCase(repository),
          getAllReportsUseCase: GetAllReportsUseCase(repository),
          repository: repository,
        );
        bloc.add(LoadAllReportsEvent());
        return bloc;
      },
        ),
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
      ],
      child: const _ReportsHoursContent(),
    );
  }
}

class _ReportsHoursContent extends StatelessWidget {
  const _ReportsHoursContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocListener<ReportBloc, ReportState>(
        listener: (context, state) {
          if (state is ReportCreated) {
            AppAlert.success(context, 'Report criado com sucesso!');
          } else if (state is ReportError) {
            AppAlert.error(context, state.message);
          }
        },
        child: BlocBuilder<ReportBloc, ReportState>(
          builder: (context, state) {
            if (state is ReportLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.blue),
              );
            }

            if (state is ReportError) {
              return Center(
                child: Text(
                  state.message,
                  style: AppTypography.paragraph(color: AppColors.error),
                ),
              );
            }

            if (state is ReportsLoaded) {
              if (state.reports.isEmpty) {
                return AppEmptyState(
                  message: 'Nenhum report cadastrado. Crie um report para começar.',
                  buttonText: 'Criar Report',
                  onPressed: () => _showCreateReportModal(context),
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
                                text: 'Criar Report',
                                onPressed: () => _showCreateReportModal(context),
                                width: 180,
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          AppDataTable(
                            headers: const [
                              'ID',
                              'Descrição',
                              'Funcionário',
                              'Squad',
                              'Horas',
                              'Data'
                            ],
                            rows: state.reports
                                .asMap()
                                .entries
                                .map((entry) => [
                                      (entry.key + 1).toString(),
                                      entry.value.description,
                                      entry.value.employeeName,
                                      entry.value.squadName,
                                      '${entry.value.hours}h',
                                      DateFormat('dd/MM/yyyy')
                                          .format(entry.value.createdAt),
                                    ])
                                .toList(),
                            actions: List.generate(
                              state.reports.length,
                              (index) => (i) {
                                ReportHoursDetailModal.show(context, state.reports[i]);
                              },
                            ),
                            actionLabels: List.generate(
                              state.reports.length,
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
                              text: 'Criar Report',
                              onPressed: () => _showCreateReportModal(context),
                              width: 180,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: state.reports.length,
                          itemBuilder: (context, index) {
                            final report = state.reports[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              child: ListTile(
                                onTap: () => ReportHoursDetailModal.show(context, report),
                                title: Text(
                                  report.description,
                                  style: AppTypography.paragraph(
                                    color: AppColors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Text(
                                  '${report.employeeName} - ${report.squadName} - ${report.hours}h',
                                  style: AppTypography.small(color: AppColors.gray4),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      DateFormat('dd/MM/yy').format(report.createdAt),
                                      style: AppTypography.small(color: AppColors.gray4),
                                    ),
                                    const SizedBox(width: 8),
                                    const Icon(Icons.chevron_right, color: AppColors.gray4),
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
              message: 'Nenhum report cadastrado. Crie um report para começar.',
              buttonText: 'Criar Report',
              onPressed: () => _showCreateReportModal(context),
            );
          },
        ),
      ),
    );
  }

  void _showCreateReportModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => Material(
        color: Colors.transparent,
        child: BlocProvider.value(
          value: context.read<ReportBloc>(),
          child: BlocProvider.value(
            value: context.read<EmployeeBloc>(),
            child: AppModal(
              child: const CreateReportModal(),
            ),
          ),
        ),
      ),
    );
  }
}

