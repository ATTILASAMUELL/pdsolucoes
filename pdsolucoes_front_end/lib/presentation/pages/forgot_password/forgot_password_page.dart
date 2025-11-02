import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pdsolucoes_front_end/core/constants/app_colors.dart';
import 'package:pdsolucoes_front_end/core/constants/app_typography.dart';
import 'package:pdsolucoes_front_end/presentation/widgets/buttons/app_button.dart';
import 'package:pdsolucoes_front_end/presentation/widgets/inputs/app_text_field.dart';
import 'package:pdsolucoes_front_end/presentation/widgets/alerts/app_alert.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;

  void _handleSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      
      Future.delayed(const Duration(seconds: 2), () {
        setState(() => _isLoading = false);
        AppAlert.success(context, 'E-mail de recuperação enviado com sucesso!');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: isSmallScreen ? double.infinity : 450,
              ),
              child: Card(
                elevation: 8,
                shadowColor: AppColors.black.withOpacity(0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: EdgeInsets.all(isSmallScreen ? 24 : 40),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                          child: SvgPicture.asset(
                            'assets/logo/pds-logo-v2 1.svg',
                            height: 80,
                            fit: BoxFit.contain,
                          ),
                        ),
                        
                        const SizedBox(height: 32),
                        
                        Text(
                          'Esqueceu sua senha?',
                          style: AppTypography.h3(color: AppColors.black),
                          textAlign: TextAlign.center,
                        ),
                        
                        const SizedBox(height: 12),
                        
                        Text(
                          'Digite seu e-mail e enviaremos instruções para redefinir sua senha',
                          style: AppTypography.paragraph(color: AppColors.gray4),
                          textAlign: TextAlign.center,
                        ),
                        
                        const SizedBox(height: 40),
                        
                        AppTextField(
                          label: 'E-mail',
                          placeholder: 'seu@email.com',
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          enabled: !_isLoading,
                        ),
                        
                        const SizedBox(height: 32),
                        
                        AppButton.primary(
                          text: 'Enviar',
                          onPressed: _isLoading ? null : _handleSubmit,
                          isLoading: _isLoading,
                          width: double.infinity,
                        ),
                        
                        const SizedBox(height: 24),
                        
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: _isLoading ? null : () {
                                Navigator.of(context).pop();
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: const Size(0, 0),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.arrow_back,
                                    size: 16,
                                    color: AppColors.blue,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Voltar para login',
                                    style: AppTypography.small(
                                      color: AppColors.blue,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}

