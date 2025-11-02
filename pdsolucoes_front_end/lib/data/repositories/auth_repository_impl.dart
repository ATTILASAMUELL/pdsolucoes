import 'package:pdsolucoes_front_end/domain/repositories/auth_repository.dart';
import 'package:pdsolucoes_front_end/data/datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl(this._remoteDataSource);

  @override
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _remoteDataSource.login(email, password);
      return {
        'user': response.user,
        'token': response.accessToken,
        'refreshToken': response.refreshToken,
      };
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> refreshToken(String refreshToken) async {
    try {
      return await _remoteDataSource.refreshToken(refreshToken);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _remoteDataSource.logout();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    try {
      await _remoteDataSource.forgotPassword(email);
    } catch (e) {
      rethrow;
    }
  }
}


