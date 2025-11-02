import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdsolucoes_front_end/core/constants/app_colors.dart';
import 'package:pdsolucoes_front_end/core/constants/app_typography.dart';
import 'package:pdsolucoes_front_end/presentation/widgets/modals/app_modal.dart';
import 'package:pdsolucoes_front_end/presentation/widgets/inputs/app_text_field.dart';
import 'package:pdsolucoes_front_end/presentation/widgets/buttons/app_button.dart';
import 'package:pdsolucoes_front_end/presentation/widgets/alerts/app_alert.dart';
import 'package:pdsolucoes_front_end/presentation/widgets/alerts/app_error_banner.dart';
import 'package:pdsolucoes_front_end/presentation/blocs/squad/squad_bloc.dart';
import 'package:pdsolucoes_front_end/presentation/blocs/squad/squad_event.dart';
import 'package:pdsolucoes_front_end/presentation/blocs/squad/squad_state.dart';

class CreateSquadModal extends StatefulWidget {
  const CreateSquadModal({Key? key}) : super(key: key);

  static Future<bool?> show(BuildContext context) {
    return AppModal.show<bool>(
      context: context,
      child: const CreateSquadModal(),
    );
  }

  @override
  State<CreateSquadModal> createState() => _CreateSquadModalState();
}

class _CreateSquadModalState extends State<CreateSquadModal> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  String? _errorMessage;

  void _handleSubmit() {
    if (_nameController.text.isEmpty) {
      AppAlert.warning(context, 'Digite o nome da squad');
      return;
    }

    context.read<SquadBloc>().add(
          CreateSquadEvent(name: _nameController.text),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SquadBloc, SquadState>(
      listener: (context, state) {
        if (state is SquadCreated) {
          AppAlert.success(context, 'Squad criada com sucesso!');
          Navigator.of(context).pop(true);
        } else if (state is SquadError) {
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
              'Criar Squad',
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
            BlocBuilder<SquadBloc, SquadState>(
              builder: (context, state) {
                final isLoading = state is SquadCreating;
                
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppTextField(
                      label: 'Nome da Squad',
                      placeholder: 'Digite o nome da squad',
                      controller: _nameController,
                      enabled: !isLoading,
                    ),
                    const SizedBox(height: 40),
                    AppButton.primary(
                      text: 'Criar Squad',
                      onPressed: isLoading ? null : _handleSubmit,
                      isLoading: isLoading,
                      width: double.infinity,
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
    super.dispose();
  }
}


