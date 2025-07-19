import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ujikom_polije/app/modules/history/views/history_view.dart';
import 'package:ujikom_polije/app/modules/presensi/views/presensi_view.dart';

class HomeController extends GetxController {
  final RxInt curretIndex = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  final List<Widget> pages = [
    const Center(
      child: Text(
        'Selamat Datang',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    ),
    PresensiView(),
    HistoryView(),
  ];

  void changePage(int index) {
    curretIndex.value = index;
  }
}
