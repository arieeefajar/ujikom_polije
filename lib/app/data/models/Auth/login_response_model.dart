import 'package:ujikom_polije/app/data/models/user_model.dart';

class LoginResponseModel {
  final bool status;
  final String message;
  final String token;
  final UserModel user;

  LoginResponseModel({
    required this.status,
    required this.message,
    required this.token,
    required this.user,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      status: json['status'],
      message: json['message'],
      token: json['data']['token'],
      user: UserModel.fromJson(json['data']['user']),
    );
  }
}
