import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

class PresensiController extends GetxController {
  late MapController mapController;
  final popUpController = PopupController();

  final Rx<LatLng> currentLocation = LatLng(
    -8.157572767586283,
    113.72278524377602,
  ).obs;
  final RxBool isLoading = true.obs;
  final RxList<Marker> markers = <Marker>[].obs;
  final LatLng schoolLocation = LatLng(-8.157572767586283, 113.72278524377602);

  @override
  void onInit() {
    super.onInit();
    mapController = MapController();
    getCurretLocation();
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
}
