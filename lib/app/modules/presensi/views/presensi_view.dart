import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';

import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

import '../controllers/presensi_controller.dart';

class PresensiView extends GetView<PresensiController> {
  const PresensiView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final distance = Distance();
      final double jarak = distance.as(
        LengthUnit.Meter,
        controller.currentLocation.value,
        controller.schoolLocation,
      );

      final bool isWithinRadius = controller.isWithinRadius(100);

      return Stack(
        children: [
          FlutterMap(
            mapController: controller.mapController,
            options: MapOptions(
              initialCenter: controller.currentLocation.value,
              initialZoom: 15.0,
              minZoom: 15.0,
              maxZoom: 18.0,
              onTap: (_, _) => controller.popUpController.hideAllPopups(),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.ujikom_polije',
              ),
              CircleLayer(
                circles: [
                  CircleMarker(
                    point: controller.schoolLocation,
                    color: Color.fromRGBO(0, 128, 0, 0.5),
                    borderStrokeWidth: 2,
                    borderColor: Colors.green,
                    radius: 100,
                    useRadiusInMeter: true,
                  ),
                ],
              ),
              PopupMarkerLayer(
                options: PopupMarkerLayerOptions(
                  markers: controller.markers.toList(),
                  popupDisplayOptions: PopupDisplayOptions(
                    builder: (context, Marker marker) => Card(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Lokasi Anda saat ini',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),
                Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16.0),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      'Jarak Anda ke Polije: ${jarak.toStringAsFixed(2)} meter',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const Spacer(),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 16),
                    FloatingActionButton(
                      onPressed: controller.getCurretLocation,
                      heroTag: 'Refresh',
                      backgroundColor: Colors.blue,
                      child: const Icon(Icons.my_location),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isWithinRadius
                                ? Colors.green
                                : Colors.grey,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: isWithinRadius
                              ? controller.presensiHadir
                              : null,
                          icon: const Icon(
                            Icons.fingerprint,
                            color: Colors.white,
                          ),
                          label: const Text(
                            'Presensi Hadir',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () => controller.showIzinDialog(context),
                          icon: const Icon(
                            Icons.edit_note,
                            color: Colors.white,
                          ),
                          label: const Text(
                            'Ajukan Izin',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    // ElevatedButton.icon(
                    //   style: ElevatedButton.styleFrom(
                    //     backgroundColor: isWithinRadius
                    //         ? Colors.green
                    //         : Colors.red,
                    //     padding: const EdgeInsets.symmetric(
                    //       horizontal: 20,
                    //       vertical: 12,
                    //     ),
                    //     shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(12),
                    //     ),
                    //   ),
                    //   onPressed: isWithinRadius
                    //       ? () {
                    //           print('Presensi Berhasil');
                    //         }
                    //       : null,
                    //   label: const Text(
                    //     'Presensi',
                    //     style: TextStyle(color: Colors.white),
                    //   ),
                    //   icon: const Icon(Icons.fingerprint, color: Colors.white),
                    // ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      );
    });
  }
}
