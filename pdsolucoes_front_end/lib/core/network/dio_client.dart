import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pdsolucoes_front_end/core/constants/app_config.dart';
import 'package:pdsolucoes_front_end/core/constants/api_endpoints.dart';
import 'package:pdsolucoes_front_end/core/utils/storage_service.dart';

class DioClient {
  static DioClient? _instance;
  late Dio _dio;
  bool _isRefreshing = false;
  List<Function> _refreshQueue = [];

  DioClient._() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.apiBaseUrl,
        connectTimeout: AppConfig.apiTimeout * 1000,
        receiveTimeout: AppConfig.apiTimeout * 1000,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          error: true,
          requestHeader: true,
          responseHeader: false,
        ),
      );
    }

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (kDebugMode) {
            print('🚀 Request: ${options.method} ${options.uri}');
            if (options.headers.containsKey('Authorization')) {
              print('🔑 Token: ${options.headers['Authorization']}');
            }
          }
          return handler.next(options);
        },
        onError: (error, handler) async {
          if (kDebugMode) {
            print('❌ Error: ${error.response?.statusCode} - ${error.message}');
          }

          if (error.response?.statusCode == 401) {
            final requestOptions = error.requestOptions;
            
            if (requestOptions.path.contains(ApiEndpoints.refreshToken) ||
                requestOptions.path.contains(ApiEndpoints.login)) {
              if (kDebugMode) {
                print('🚫 Auth endpoint failed, clearing data');
              }
              await _handleLogout();
              return handler.next(error);
            }

            if (_isRefreshing) {
              if (kDebugMode) {
                print('⏳ Refresh already in progress, queuing request');
              }
              return _addToQueue(requestOptions, handler);
            }

            _isRefreshing = true;

            try {
              if (kDebugMode) {
                print('🔄 Attempting token refresh');
              }

              final refreshToken = await StorageService.getRefreshToken();
              
              if (refreshToken == null || refreshToken.isEmpty) {
                throw Exception('No refresh token available');
              }

              final response = await _dio.post(
                ApiEndpoints.refreshToken,
                data: {'refreshToken': refreshToken},
              );

              final newToken = response.data['data']['accessToken'] ?? '';
              final newRefreshToken = response.data['data']['refreshToken'] ?? '';

              if (newToken.isEmpty) {
                throw Exception('Invalid token received');
              }

              setAuthToken(newToken);

              final userData = await StorageService.getUserData();
              await StorageService.saveAuthData(
                token: newToken,
                refreshToken: newRefreshToken,
                userId: userData['userId'] ?? '',
                userEmail: userData['userEmail'] ?? '',
                userName: userData['userName'] ?? '',
              );

              if (kDebugMode) {
                print('✅ Token refreshed successfully');
              }

              _isRefreshing = false;
              _processQueue();

              requestOptions.headers['Authorization'] = 'Bearer $newToken';
              final retryResponse = await _dio.fetch(requestOptions);
              return handler.resolve(retryResponse);
            } catch (e) {
              if (kDebugMode) {
                print('❌ Token refresh failed: $e');
              }
              _isRefreshing = false;
              _clearQueue();
              await _handleLogout();
              return handler.next(error);
            }
          }

          return handler.next(error);
        },
      ),
    );
  }

  Future<void> _addToQueue(RequestOptions options, ErrorInterceptorHandler handler) async {
    _refreshQueue.add(() async {
      try {
        final response = await _dio.fetch(options);
        handler.resolve(response);
      } catch (e) {
        handler.reject(DioError(
          requestOptions: options,
          error: e,
        ));
      }
    });
  }

  void _processQueue() {
    for (var callback in _refreshQueue) {
      callback();
    }
    _refreshQueue.clear();
  }

  void _clearQueue() {
    _refreshQueue.clear();
  }

  Future<void> _handleLogout() async {
    try {
      await StorageService.clearAuthData();
      removeAuthToken();
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error clearing auth data: $e');
      }
    }
  }

  static DioClient get instance {
    _instance ??= DioClient._();
    return _instance!;
  }

  Dio get dio => _dio;

  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  void removeAuthToken() {
    _dio.options.headers.remove('Authorization');
  }
}

