import 'package:get/get.dart';
import 'package:ujikom_polije/app/data/models/presensi_riwayat_model.dart';

class HistoryController extends GetxController {
  var isLoading = false.obs;
  var listRiwayat = <PresensiRiwayatModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    // fetchRiwayat();
  }

  void fetchRiwayat() async {
    // try {
    //   isLoading.value = true;
    //   final response = await _provider.getRiwayatPresensi();
    //   if (response.statusCode == 200 && response.body['success'] == true) {
    //     final List data = response.body['data'];
    //     listRiwayat.value = data
    //         .map((e) => PresensiRiwayatModel.fromJson(e))
    //         .toList();
    //   } else {
    //     Get.snackbar("Error", response.body['message'] ?? "Gagal memuat data");
    //   }
    // } catch (e) {
    //   Get.snackbar("Error", "Terjadi kesalahan: $e");
    // } finally {
    //   isLoading.value = false;
    // }
  }
}
