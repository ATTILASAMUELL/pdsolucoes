import 'package:pdsolucoes_front_end/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<Map<String, dynamic>> call(String email, String password) async {
    if (email.isEmpty) {
      throw Exception('E-mail é obrigatório');
    }

    if (password.isEmpty) {
      throw Exception('Senha é obrigatória');
    }

    if (!email.contains('@')) {
      throw Exception('E-mail inválido');
    }

    return await repository.login(email, password);
  }
}




