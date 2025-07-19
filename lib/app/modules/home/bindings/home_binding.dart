import 'package:get/get.dart';
import 'package:ujikom_polije/app/data/providers/presensi_provider.dart';
import 'package:ujikom_polije/app/modules/history/controllers/history_controller.dart';
import 'package:ujikom_polije/app/modules/presensi/controllers/presensi_controller.dart';

import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<PresensiController>(() => PresensiController());
    Get.lazyPut<PresensiProvider>(() => PresensiProvider());
    Get.lazyPut<HistoryController>(() => HistoryController());
  }
}
