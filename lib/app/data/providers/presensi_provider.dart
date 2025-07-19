import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ujikom_polije/app/core/values/constants.dart';

class PresensiProvider extends GetConnect {
  @override
  void onInit() {
    httpClient.baseUrl = AppConstants.baseUrl;
    httpClient.defaultContentType = "application/json";
    httpClient.timeout = const Duration(seconds: 30);
  }

  Future<Response> presensiHadir() async {
    return await post('/presensi-hadir', {});
  }

  Future<Response> presensiIzin(String alasan) async {
    return await post('/presensi-izin', {'data': alasan});
  }
}
