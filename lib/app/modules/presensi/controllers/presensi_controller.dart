import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:latlong2/latlong.dart';
import 'package:ujikom_polije/app/data/models/user_model.dart';
import 'package:ujikom_polije/app/data/providers/presensi_provider.dart';

class PresensiController extends GetxController {
  final presensiProvider = Get.find<PresensiProvider>();
  late MapController mapController;
  final popUpController = PopupController();
  final storage = GetStorage();
  late String token;
  late UserModel userMap;

  final Rx<LatLng> currentLocation = LatLng(
    -8.157572767586283,
    113.72278524377602,
  ).obs;
  final RxBool isLoading = true.obs;
  final RxList<Marker> markers = <Marker>[].obs;
  final LatLng schoolLocation = LatLng(-8.157572767586283, 113.72278524377602);
  final alasanController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    mapController = MapController();
    token = storage.read('token');
    userMap = storage.read('user');
    getCurretLocation();
  }

  @override
  void onClose() {
    super.onClose();
    alasanController.dispose();
  }

  Future<void> getCurretLocation() async {
    isLoading.value = true;

    if (!await Geolocator.isLocationServiceEnabled()) {
      isLoading.value = false;
      Get.dialog(
        AlertDialog(
          title: Text('Layanan Lokasi Nonaktif'),
          content: Text('Silakan aktifkan layanan lokasi.'),
          actions: [
            TextButton(
              onPressed: () {
                Geolocator.openLocationSettings();
                Get.back();
              },
              child: Text('Buka Pengaturan'),
            ),
          ],
        ),
      );
      return;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      isLoading.value = false;
      Get.snackbar('Izin Ditolak', 'Aplikasi membutuhkan izin lokasi.');
      return;
    }

    try {
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 0,
          timeLimit: const Duration(seconds: 10),
        ),
      );
      currentLocation.value = LatLng(pos.latitude, pos.longitude);
      markers.assignAll([
        Marker(
          point: currentLocation.value,
          height: 40.0,
          width: 40.0,
          child: const Icon(
            Icons.location_on_sharp,
            size: 40.0,
            color: Colors.red,
          ),
        ),
      ]);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        mapController.move(currentLocation.value, 15);
        popUpController.showPopupsOnlyFor(markers.toList());
      });
    } catch (e) {
      String errorMsg = 'Gagal mendapatkan lokasi.';

      if (e is LocationServiceDisabledException) {
        errorMsg = 'Layanan lokasi tidak aktif.';
      } else if (e is PermissionDeniedException) {
        errorMsg = 'Izin lokasi ditolak.';
      }

      Get.snackbar('Error', errorMsg);
      isLoading.value = false;
      return;
    } finally {
      isLoading.value = false;
    }
  }

  void moveToCurrentLocation() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      mapController.move(currentLocation.value, 15);
      popUpController.showPopupsOnlyFor(markers.toList());
    });
  }

  bool isWithinRadius(double radiusInMeters) {
    final Distance distance = Distance();
    final double jarak = distance.as(
      LengthUnit.Meter,
      currentLocation.value,
      schoolLocation,
    );
    return jarak <= radiusInMeters;
  }

  void presensiHadir() async {
    if (!isWithinRadius(100)) {
      showSnackbar(
        "Gagal Presensi",
        "Anda berada di luar radius yang diizinkan.",
      );
      return;
    }

    try {
      isLoading.value = true;
      final response = await presensiProvider.presensiHadir();

      if (response.statusCode == 200) {
        final body = response.body;
        if (body['success'] == true) {
          showSnackbar(
            "Berhasil",
            body['message'] ?? "Presensi berhasil",
            backgroundColor: Colors.green,
          );
        } else {
          showSnackbar("Gagal", body['message'] ?? "Gagal melakukan presensi");
        }
      } else {
        showSnackbar("Error", "Terjadi kesalahan server");
      }
    } catch (e) {
      showSnackbar("Error", "Gagal melakukan presensi: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void presensiIzin(String alasan) async {
    if (alasan.trim().isEmpty) {
      showSnackbar("Peringatan", "Alasan tidak boleh kosong");
      return;
    }

    try {
      isLoading.value = true;
      final response = await presensiProvider.presensiIzin(alasan);

      if (response.statusCode == 200) {
        final body = response.body;
        if (body['success'] == true) {
          showSnackbar(
            "Berhasil",
            body['message'] ?? "Izin berhasil",
            backgroundColor: Colors.orange,
          );
        } else {
          showSnackbar("Gagal", body['message'] ?? "Gagal mengirim izin");
        }
      } else {
        showSnackbar("Error", "Terjadi kesalahan server");
      }
    } catch (e) {
      showSnackbar("Error", "Gagal mengirim izin: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void showIzinDialog(BuildContext context) {
    alasanController.clear();

    Get.dialog(
      AlertDialog(
        title: const Text('Ajukan Izin'),
        content: TextField(
          controller: alasanController,
          decoration: const InputDecoration(hintText: 'Masukkan alasan izin'),
          maxLines: 3,
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              presensiIzin(alasanController.text);
              Get.back();
            },
            child: const Text('Kirim'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  void showSnackbar(
    String title,
    String message, {
    Color backgroundColor = Colors.red,
  }) {
    Get.snackbar(
      title,
      message,
      backgroundColor: backgroundColor,
      colorText: Colors.white,
    );
  }
}
