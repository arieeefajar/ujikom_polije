import 'package:get/get.dart';
import 'package:ujikom_polije/app/data/providers/presensi_provider.dart';

import '../controllers/presensi_controller.dart';

class PresensiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PresensiController>(() => PresensiController());
    Get.lazyPut<PresensiProvider>(() => PresensiProvider());
  }
}
