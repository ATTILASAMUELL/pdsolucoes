import 'package:pdsolucoes_front_end/data/models/user_model.dart';

class AuthResponseModel {
  final bool success;
  final String message;
  final UserModel user;
  final String accessToken;
  final String refreshToken;

  AuthResponseModel({
    required this.success,
    required this.message,
    required this.user,
    required this.accessToken,
    required this.refreshToken,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      user: UserModel.fromJson(json['data']['user'] ?? {}),
      accessToken: json['data']['accessToken'] ?? '',
      refreshToken: json['data']['refreshToken'] ?? '',
    );
  }
}



