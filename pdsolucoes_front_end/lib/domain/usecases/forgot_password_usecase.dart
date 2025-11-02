import 'package:pdsolucoes_front_end/domain/repositories/auth_repository.dart';

class ForgotPasswordUseCase {
  final AuthRepository repository;

  ForgotPasswordUseCase(this.repository);

  Future<void> call(String email) async {
    if (email.isEmpty) {
      throw Exception('E-mail é obrigatório');
    }

    if (!email.contains('@')) {
      throw Exception('E-mail inválido');
    }

    return await repository.forgotPassword(email);
  }
}




