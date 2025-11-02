import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdsolucoes_front_end/core/constants/app_colors.dart';
import 'package:pdsolucoes_front_end/core/constants/app_typography.dart';
import 'package:pdsolucoes_front_end/presentation/blocs/report/report_bloc.dart';
import 'package:pdsolucoes_front_end/presentation/blocs/report/report_event.dart';
import 'package:pdsolucoes_front_end/presentation/blocs/report/report_state.dart';
import 'package:pdsolucoes_front_end/data/datasources/report_remote_datasource.dart';
import 'package:pdsolucoes_front_end/data/repositories/report_repository_impl.dart';
import 'package:pdsolucoes_front_end/domain/usecases/create_report_usecase.dart';
import 'package:pdsolucoes_front_end/domain/usecases/get_dashboard_usecase.dart';
import 'package:pdsolucoes_front_end/domain/usecases/get_all_reports_usecase.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final dataSource = ReportRemoteDataSource();
        final repository = ReportRepositoryImpl(dataSource);
        final bloc = ReportBloc(
          createReportUseCase: CreateReportUseCase(repository),
          getDashboardUseCase: GetDashboardUseCase(repository),
          getAllReportsUseCase: GetAllReportsUseCase(repository),
          repository: repository,
        );
        bloc.add(LoadDashboardEvent());
        return bloc;
      },
      child: const _ReportsPageContent(),
    );
  }
}

class _ReportsPageContent extends StatelessWidget {
  const _ReportsPageContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Dashboard', style: AppTypography.h4()),
        backgroundColor: AppColors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: BlocBuilder<ReportBloc, ReportState>(
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

          if (state is DashboardLoaded) {
            final dashboard = state.dashboard;

            return SingleChildScrollView(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width > 600 ? 24 : 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Visão Geral',
                    style: AppTypography.h3(color: AppColors.black),
                  ),
                  const SizedBox(height: 24),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isWeb = constraints.maxWidth > 600;
                      final columns = isWeb ? 4 : 2;

                      return GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: columns,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: isWeb ? 2.5 : 1.5,
                        children: [
                          _buildStatCard(
                            'Total de Squads',
                            dashboard.totalSquads.toString(),
                            AppColors.blue,
                            Icons.groups,
                          ),
                          _buildStatCard(
                            'Total de Employees',
                            dashboard.totalEmployees.toString(),
                            AppColors.purple,
                            Icons.person,
                          ),
                          _buildStatCard(
                            'Total de Reports',
                            dashboard.totalReports.toString(),
                            AppColors.green,
                            Icons.assignment,
                          ),
                          _buildStatCard(
                            'Média de Horas/Dia',
                            '${dashboard.averageHoursPerDay.toStringAsFixed(1)}h',
                            AppColors.warning,
                            Icons.access_time,
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 40),
                  Text(
                    'Estatísticas por Squad',
                    style: AppTypography.h3(color: AppColors.black),
                  ),
                  const SizedBox(height: 24),
                  if (dashboard.squadStats.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(40),
                        child: Text(
                          'Nenhuma squad com dados',
                          style: AppTypography.paragraph(color: AppColors.gray4),
                        ),
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: dashboard.squadStats.length,
                      itemBuilder: (context, index) {
                        final squad = dashboard.squadStats[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: AppColors.blue.withOpacity(0.1),
                              child: const Icon(
                                Icons.groups,
                                color: AppColors.blue,
                              ),
                            ),
                            title: Text(
                              squad.squadName,
                              style: AppTypography.paragraph(
                                color: AppColors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Text(
                              '${squad.employeeCount} employees',
                              style: AppTypography.small(color: AppColors.gray4),
                            ),
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.blue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '${squad.totalHours}h',
                                style: AppTypography.paragraph(
                                  color: AppColors.blue,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    Color color,
    IconData icon,
  ) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.gray2, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: AppTypography.small(
                      color: AppColors.gray4,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(icon, color: color, size: 20),
              ],
            ),
            const SizedBox(height: 4),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                value,
                style: AppTypography.h3(color: color),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

