import 'package:get/get.dart';
import 'package:ujikom_polije/app/core/values/constants.dart';
import 'package:ujikom_polije/app/data/models/Auth/login_request_model.dart';
import 'package:ujikom_polije/app/data/models/Auth/login_response_model.dart';

class AuthProvider extends GetConnect {
  @override
  void onInit() {
    httpClient.baseUrl = AppConstants.baseUrl;
    httpClient.defaultContentType = "application/json";
    httpClient.timeout = const Duration(seconds: 30);
  }

  Future<LoginResponseModel?> login(LoginRequestModel request) async {
    final response = await post('/login', request.toJson());

    if (response.statusCode == 200 && response.body != null) {
      return LoginResponseModel.fromJson(response.body);
    } else {
      return null;
    }
  }
}
