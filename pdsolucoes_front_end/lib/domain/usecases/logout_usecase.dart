import 'package:pdsolucoes_front_end/domain/repositories/auth_repository.dart';
import 'package:pdsolucoes_front_end/core/utils/storage_service.dart';

class LogoutUseCase {
  final AuthRepository repository;

  LogoutUseCase(this.repository);

  Future<void> call() async {
    try {
      await repository.logout();
    } finally {
      await StorageService.clearAuthData();
    }
  }
}



