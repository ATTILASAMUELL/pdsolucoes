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
import 'package:pdsolucoes_front_end/presentation/pages/squads/widgets/create_squad_modal.dart';
import 'package:pdsolucoes_front_end/presentation/pages/squads/widgets/view_squad_modal.dart';
import 'package:pdsolucoes_front_end/presentation/blocs/squad/squad_bloc.dart';
import 'package:pdsolucoes_front_end/presentation/blocs/squad/squad_event.dart';
import 'package:pdsolucoes_front_end/presentation/blocs/squad/squad_state.dart';

class SquadsPage extends StatefulWidget {
  const SquadsPage({Key? key}) : super(key: key);

  @override
  State<SquadsPage> createState() => _SquadsPageState();
}

class _SquadsPageState extends State<SquadsPage> {
  final _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String value, BuildContext blocContext) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    
    _debounce = Timer(const Duration(milliseconds: 500), () {
      blocContext.read<SquadBloc>().add(LoadSquadsEvent(search: value.isEmpty ? null : value));
    });
  }

  void _onSearchPressed(BuildContext blocContext) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    blocContext.read<SquadBloc>().add(
      LoadSquadsEvent(search: _searchController.text.isEmpty ? null : _searchController.text),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Squads', style: AppTypography.h4()),
        backgroundColor: AppColors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Builder(
        builder: (blocContext) => BlocBuilder<SquadBloc, SquadState>(
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

          if (state is SquadSearching || state is SquadLoaded) {
            final squads = state is SquadLoaded 
                ? state.squads 
                : (state as SquadSearching).currentSquads;
            
            // Verifica se há uma busca ativa
            final isSearching = _searchController.text.isNotEmpty;

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
                                placeholder: 'Buscar squad por nome...',
                                controller: _searchController,
                                onChanged: (value) => _onSearchChanged(value, blocContext),
                                prefixIcon: const Icon(
                                  Icons.search,
                                  color: AppColors.gray4,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            AppButton(
                              text: 'Buscar',
                              onPressed: () => _onSearchPressed(blocContext),
                              width: 120,
                            ),
                            const SizedBox(width: 12),
                            AppButton(
                              text: 'Criar Squad',
                              onPressed: () => _showCreateSquadModal(context),
                              width: 180,
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        // Área da tabela
                        if (squads.isEmpty)
                          Expanded(
                            child: _buildEmptyState(isSearching, context),
                          )
                        else
                          AppDataTable(
                            headers: const ['ID', 'Nome'],
                            rows: squads
                                .asMap()
                                .entries
                                .map((entry) => [
                                      (entry.key + 1).toString(),
                                      entry.value.name,
                                    ])
                                .toList(),
                            actions: List.generate(
                              squads.length,
                              (index) => (i) {
                                ViewSquadModal.show(context, squads[i]);
                              },
                            ),
                            actionLabels: List.generate(
                              squads.length,
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
                                  placeholder: 'Buscar squad por nome...',
                                  controller: _searchController,
                                  onChanged: (value) => _onSearchChanged(value, blocContext),
                                  prefixIcon: const Icon(
                                    Icons.search,
                                    color: AppColors.gray4,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              AppButton(
                                text: 'Buscar',
                                onPressed: () => _onSearchPressed(blocContext),
                                width: 120,
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
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
                        ],
                      ),
                    ),
                    // Área da lista
                    Expanded(
                      child: squads.isEmpty
                          ? _buildEmptyState(isSearching, context)
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              itemCount: squads.length,
                              itemBuilder: (context, index) {
                                final squad = squads[index];
                                return Card(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  child: ListTile(
                                    title: Text(
                                      squad.name,
                                      style: AppTypography.paragraph(color: AppColors.black),
                                    ),
                                    trailing: const Icon(Icons.chevron_right, color: AppColors.gray4),
                                    onTap: () => ViewSquadModal.show(context, squad),
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
            message: 'Nenhuma squad cadastrada. Crie uma squad para começar.',
            buttonText: 'Criar Squad',
            onPressed: () => _showCreateSquadModal(context),
          );
        },
        ),
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

  Widget _buildEmptyState(bool isSearching, BuildContext context) {
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
        message: 'Nenhuma squad cadastrada. Crie uma squad para começar.',
        buttonText: 'Criar Squad',
        onPressed: () => _showCreateSquadModal(context),
      ),
    );
  }
}
