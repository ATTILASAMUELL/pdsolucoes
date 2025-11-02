import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdsolucoes_front_end/core/constants/app_colors.dart';
import 'package:pdsolucoes_front_end/core/constants/app_typography.dart';
import 'package:pdsolucoes_front_end/presentation/widgets/buttons/app_button.dart';
import 'package:pdsolucoes_front_end/presentation/widgets/inputs/app_text_field.dart';
import 'package:pdsolucoes_front_end/presentation/widgets/alerts/app_alert.dart';
import 'package:pdsolucoes_front_end/presentation/pages/forgot_password/forgot_password_page.dart';
import 'package:pdsolucoes_front_end/presentation/blocs/auth/auth_bloc.dart';
import 'package:pdsolucoes_front_end/presentation/blocs/auth/auth_event.dart';
import 'package:pdsolucoes_front_end/presentation/blocs/auth/auth_state.dart';
import 'package:pdsolucoes_front_end/data/datasources/auth_remote_datasource.dart';
import 'package:pdsolucoes_front_end/data/repositories/auth_repository_impl.dart';
import 'package:pdsolucoes_front_end/domain/usecases/login_usecase.dart';
import 'package:pdsolucoes_front_end/domain/usecases/logout_usecase.dart';
import 'package:pdsolucoes_front_end/domain/usecases/forgot_password_usecase.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final dataSource = AuthRemoteDataSource();
        final repository = AuthRepositoryImpl(dataSource);
        return AuthBloc(
          loginUseCase: LoginUseCase(repository),
          logoutUseCase: LogoutUseCase(repository),
          forgotPasswordUseCase: ForgotPasswordUseCase(repository),
        );
      },
      child: const _LoginPageContent(),
    );
  }
}

class _LoginPageContent extends StatefulWidget {
  const _LoginPageContent({Key? key}) : super(key: key);

  @override
  State<_LoginPageContent> createState() => _LoginPageContentState();
}

class _LoginPageContentState extends State<_LoginPageContent> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _handleLogin() {
    if (_emailController.text.isEmpty) {
      AppAlert.warning(context, 'Digite seu e-mail');
      return;
    }

    if (_passwordController.text.isEmpty) {
      AppAlert.warning(context, 'Digite sua senha');
      return;
    }

    context.read<AuthBloc>().add(
          LoginEvent(
            email: _emailController.text,
            password: _passwordController.text,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          AppAlert.success(context, 'Login realizado com sucesso!');
          Navigator.of(context).pushReplacementNamed('/dashboard');
        } else if (state is AuthError) {
          AppAlert.error(context, state.message);
        }
      },
      child: Scaffold(
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
                          'Faça login para continuar',
                          style: AppTypography.paragraph(color: AppColors.gray4),
                          textAlign: TextAlign.center,
                        ),
                        
                        const SizedBox(height: 40),
                        
                        BlocBuilder<AuthBloc, AuthState>(
                          builder: (context, state) {
                            final isLoading = state is AuthLoading;
                            
                            return Column(
                              children: [
                                AppTextField(
                                  label: 'E-mail',
                                  placeholder: 'seu@email.com',
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  enabled: !isLoading,
                                ),
                                
                                const SizedBox(height: 20),
                                
                                AppTextField(
                                  label: 'Senha',
                                  placeholder: '••••••••',
                                  controller: _passwordController,
                                  obscureText: true,
                                  enabled: !isLoading,
                                ),
                              ],
                            );
                          },
                        ),
                        
                        const SizedBox(height: 12),
                        
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ForgotPasswordPage(),
                                ),
                              );
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: const Size(0, 0),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              'Esqueceu a senha?',
                              style: AppTypography.small(
                                color: AppColors.blue,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 32),
                        
                        BlocBuilder<AuthBloc, AuthState>(
                          builder: (context, state) {
                            final isLoading = state is AuthLoading;
                            
                            return AppButton.primary(
                              text: 'Entrar',
                              onPressed: isLoading ? null : _handleLogin,
                              isLoading: isLoading,
                              width: double.infinity,
                            );
                          },
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
    ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

