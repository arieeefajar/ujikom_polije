import 'package:get/get.dart';
import 'package:ujikom_polije/app/core/values/constants.dart';

class ApiProvider extends GetConnect {
  @override
  void onInit() {
    httpClient.baseUrl = AppConstants.baseUrl;
    httpClient.timeout = Duration(seconds: AppConstants.connectTimeout);
    httpClient.defaultContentType = "application/json";

    // Optional: Tambah headers default
    httpClient.addRequestModifier<void>((request) {
      request.headers['Accept'] = 'application/json';
      return request;
    });
  }
}
