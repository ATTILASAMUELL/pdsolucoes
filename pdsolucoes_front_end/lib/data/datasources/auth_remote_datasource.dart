import 'package:dio/dio.dart';
import 'package:pdsolucoes_front_end/core/network/dio_client.dart';
import 'package:pdsolucoes_front_end/core/constants/api_endpoints.dart';
import 'package:pdsolucoes_front_end/data/models/auth_response_model.dart';

class AuthRemoteDataSource {
  final Dio _dio = DioClient.instance.dio;

  Future<AuthResponseModel> login(String email, String password) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.login,
        data: {
          'email': email,
          'password': password,
        },
      );

      print('📦 Login Response: ${response.data}');
      
      final authResponse = AuthResponseModel.fromJson(response.data);
      print('🔑 Access Token: ${authResponse.accessToken}');
      print('🔄 Refresh Token: ${authResponse.refreshToken}');
      
      return authResponse;
    } on DioError catch (e) {
      if (e.response != null) {
        final message = e.response?.data['message'] ?? 'Erro ao fazer login';
        throw Exception(message);
      }
      throw Exception('Erro de conexão. Verifique sua internet.');
    } catch (e) {
      throw Exception('Erro inesperado: ${e.toString()}');
    }
  }

  Future<void> forgotPassword(String email) async {
    try {
      await _dio.post(
        ApiEndpoints.forgotPassword,
        data: {'email': email},
      );
    } on DioError catch (e) {
      if (e.response != null) {
        final message = e.response?.data['message'] ?? 'Erro ao enviar e-mail';
        throw Exception(message);
      }
      throw Exception('Erro de conexão. Verifique sua internet.');
    } catch (e) {
      throw Exception('Erro inesperado: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> refreshToken(String refreshToken) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.refreshToken,
        data: {'refreshToken': refreshToken},
      );

      return {
        'token': response.data['data']['token'] ?? '',
        'refreshToken': response.data['data']['refreshToken'] ?? '',
      };
    } on DioError catch (e) {
      if (e.response != null) {
        final message = e.response?.data['message'] ?? 'Erro ao atualizar token';
        throw Exception(message);
      }
      throw Exception('Erro de conexão. Verifique sua internet.');
    } catch (e) {
      throw Exception('Erro inesperado: ${e.toString()}');
    }
  }

  Future<void> logout() async {
    try {
      await _dio.post(ApiEndpoints.logout);
    } on DioError catch (e) {
      if (e.response != null) {
        final message = e.response?.data['message'] ?? 'Erro ao fazer logout';
        throw Exception(message);
      }
      throw Exception('Erro de conexão. Verifique sua internet.');
    } catch (e) {
      throw Exception('Erro inesperado: ${e.toString()}');
    }
  }
}

