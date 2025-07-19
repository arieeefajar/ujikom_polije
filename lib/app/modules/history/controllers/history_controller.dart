import 'package:get/get.dart';
import 'package:ujikom_polije/app/data/models/presensi_riwayat_model.dart';
import 'package:ujikom_polije/app/data/providers/riwayat_presensi_provider.dart';

class HistoryController extends GetxController {
  final riwayatProvider = Get.find<RiwayatPresensiProvider>();
  var isLoading = false.obs;
  var listRiwayat = <PresensiRiwayatModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchRiwayat();
  }

  void fetchRiwayat() async {
    try {
      isLoading.value = true;
      final response = await riwayatProvider.getRiwayatPresensi();
      if (response.statusCode == 200 && response.body['success'] == true) {
        final List data = response.body['data'];
        listRiwayat.value = data
            .map((e) => PresensiRiwayatModel.fromJson(e))
            .toList();
      } else {
        Get.snackbar("Error", response.body['message'] ?? "Gagal memuat data");
      }
    } catch (e) {
      Get.snackbar("Error", "Terjadi kesalahan: $e");
    } finally {
      isLoading.value = false;
    }
  }

  String formatDate(String date) {
    try {
      final DateTime dateTime = DateTime.parse(date);
      final List<String> months = [
        'Januari',
        'Februari',
        'Maret',
        'April',
        'Mei',
        'Juni',
        'Juli',
        'Agustus',
        'September',
        'Oktober',
        'November',
        'Desember',
      ];
      final List<String> days = [
        'Minggu',
        'Senin',
        'Selasa',
        'Rabu',
        'Kamis',
        'Jumat',
        'Sabtu',
      ];

      return '${days[dateTime.weekday % 7]}, ${dateTime.day} ${months[dateTime.month - 1]} ${dateTime.year}';
    } catch (e) {
      return date; // Return original date if parsing fails
    }
  }
}
