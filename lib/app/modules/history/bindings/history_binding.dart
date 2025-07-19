import 'package:get/get.dart';
import 'package:ujikom_polije/app/data/providers/riwayat_presensi_provider.dart';

import '../controllers/history_controller.dart';

class HistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HistoryController>(() => HistoryController());
    Get.lazyPut<RiwayatPresensiProvider>(() => RiwayatPresensiProvider());
  }
}
