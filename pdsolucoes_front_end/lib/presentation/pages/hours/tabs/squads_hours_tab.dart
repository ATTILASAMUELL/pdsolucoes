import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdsolucoes_front_end/core/constants/app_colors.dart';
import 'package:pdsolucoes_front_end/core/constants/app_typography.dart';
import 'package:pdsolucoes_front_end/presentation/widgets/empty_state/app_empty_state.dart';
import 'package:pdsolucoes_front_end/presentation/widgets/tables/app_data_table.dart';
import 'package:pdsolucoes_front_end/presentation/widgets/buttons/app_button.dart';
import 'package:pdsolucoes_front_end/presentation/widgets/modals/app_modal.dart';
import 'package:pdsolucoes_front_end/presentation/pages/squads/widgets/create_squad_modal.dart';
import 'package:pdsolucoes_front_end/presentation/pages/hours/widgets/squad_hours_detail_modal.dart';
import 'package:pdsolucoes_front_end/presentation/blocs/squad/squad_bloc.dart';
import 'package:pdsolucoes_front_end/presentation/blocs/squad/squad_state.dart';
import 'package:pdsolucoes_front_end/presentation/blocs/squad/squad_event.dart';
import 'package:pdsolucoes_front_end/data/datasources/squad_remote_datasource.dart';
import 'package:pdsolucoes_front_end/data/repositories/squad_repository_impl.dart';
import 'package:pdsolucoes_front_end/domain/usecases/get_all_squads_usecase.dart';
import 'package:pdsolucoes_front_end/domain/usecases/create_squad_usecase.dart';

class SquadsHoursTab extends StatelessWidget {
  const SquadsHoursTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
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
      child: const _SquadsHoursContent(),
    );
  }
}

class _SquadsHoursContent extends StatelessWidget {
  const _SquadsHoursContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocBuilder<SquadBloc, SquadState>(
        builder: (context, state) {
          if (state is SquadLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.blue),
            );
          }

          if (state is SquadError) {
            return Center(
              child: Text(
                state.message,
                style: AppTypography.paragraph(color: AppColors.error),
              ),
            );
          }

          if (state is SquadLoaded) {
            if (state.squads.isEmpty) {
              return AppEmptyState(
                message: 'Nenhuma squad encontrada. Crie uma squad para começar.',
                buttonText: 'Criar Squad',
                onPressed: () => _showCreateSquadModal(context),
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
                              text: 'Criar Squad',
                              onPressed: () => _showCreateSquadModal(context),
                              width: 180,
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        AppDataTable(
                          headers: const ['ID', 'Nome', 'Total Horas', 'Média/Dia', 'Membros'],
                          rows: state.squads
                              .asMap()
                              .entries
                              .map((entry) => [
                                    (entry.key + 1).toString(),
                                    entry.value.name,
                                    '0h',
                                    '0h',
                                    '0',
                                  ])
                              .toList(),
                          actions: List.generate(
                            state.squads.length,
                            (index) => (i) {
                              SquadHoursDetailModal.show(context, state.squads[i]);
                            },
                          ),
                          actionLabels: List.generate(
                            state.squads.length,
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
                            text: 'Criar Squad',
                            onPressed: () => _showCreateSquadModal(context),
                            width: 180,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: state.squads.length,
                        itemBuilder: (context, index) {
                          final squad = state.squads[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: InkWell(
                              onTap: () => SquadHoursDetailModal.show(context, squad),
                              borderRadius: BorderRadius.circular(8),
                              child: ExpansionTile(
                                leading: CircleAvatar(
                                  backgroundColor: AppColors.blue.withOpacity(0.1),
                                  child: const Icon(Icons.groups, color: AppColors.blue),
                                ),
                                title: Text(
                                  squad.name,
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
                                        'Total de Horas',
                                        '0h',
                                        Icons.access_time,
                                      ),
                                      const SizedBox(height: 12),
                                      _buildInfoRow(
                                        'Média de Horas/Dia',
                                        '0h',
                                        Icons.trending_up,
                                      ),
                                      const SizedBox(height: 12),
                                      _buildInfoRow(
                                        'Membros',
                                        '0',
                                        Icons.people,
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
            message: 'Nenhuma squad encontrada.',
            buttonText: 'Criar Squad',
            onPressed: () => _showCreateSquadModal(context),
          );
        },
      ),
    );
  }

  void _showCreateSquadModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => Material(
        color: Colors.transparent,
        child: BlocProvider.value(
          value: context.read<SquadBloc>(),
          child: AppModal(
            child: const CreateSquadModal(),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.blue),
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

