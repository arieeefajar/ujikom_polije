import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ujikom_polije/app/core/values/constants.dart';

class RiwayatPresensiProvider extends GetConnect {
  final storage = GetStorage();

  @override
  void onInit() {
    httpClient.baseUrl = AppConstants.baseUrl;
    httpClient.defaultContentType = "application/json";
    httpClient.timeout = const Duration(seconds: 30);
  }

  Future<Map<String, String>> _getHeaders() async {
    final token = await storage.read('token');
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }

  Future<Response> getRiwayatPresensi() async {
    return await get('/presensi-history', headers: await _getHeaders());
  }
}
