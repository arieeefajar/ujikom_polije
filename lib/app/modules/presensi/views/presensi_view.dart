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
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withAlpha(25),
                        spreadRadius: 0,
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Mengambil lokasi...',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
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
            // Map Layer
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              child: SizedBox(
                // height: MediaQuery.of(context).size.height * 0.6,
                child: FlutterMap(
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
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.ujikom_polije',
                    ),
                    CircleLayer(
                      circles: [
                        CircleMarker(
                          point: controller.schoolLocation,
                          color: Colors.blue.withAlpha(50),
                          borderStrokeWidth: 3,
                          borderColor: Colors.blue.shade600,
                          radius: 100,
                          useRadiusInMeter: true,
                        ),
                      ],
                    ),
                    PopupMarkerLayer(
                      options: PopupMarkerLayerOptions(
                        markers: controller.markers.toList(),
                        popupDisplayOptions: PopupDisplayOptions(
                          builder: (context, Marker marker) => Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withAlpha(25),
                                  blurRadius: 10,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Text(
                              'Lokasi Anda',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Distance Info Card
            Positioned(
              top: 20,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.white, Colors.white.withAlpha(200)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(25),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isWithinRadius
                            ? Colors.green.shade50
                            : Colors.red.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.location_on,
                        color: isWithinRadius ? Colors.green : Colors.red,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Jarak ke Polije',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '${jarak.toStringAsFixed(0)} meter',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: isWithinRadius
                            ? Colors.green.shade100
                            : Colors.red.shade100,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        isWithinRadius ? 'Dalam Area' : 'Luar Area',
                        style: TextStyle(
                          color: isWithinRadius
                              ? Colors.green.shade800
                              : Colors.red.shade800,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Action Sheet
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 20,
                      offset: Offset(0, -5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Handle Bar
                    Container(
                      margin: const EdgeInsets.only(top: 12, bottom: 20),
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),

                    // Status Card
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isWithinRadius
                              ? [Colors.green.shade50, Colors.green.shade100]
                              : [Colors.red.shade50, Colors.red.shade100],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isWithinRadius
                              ? Colors.green.shade200
                              : Colors.red.shade200,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isWithinRadius
                                ? Icons.check_circle_outline
                                : Icons.warning_outlined,
                            color: isWithinRadius
                                ? Colors.green.shade700
                                : Colors.red.shade700,
                            size: 28,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  isWithinRadius
                                      ? 'Siap untuk Presensi'
                                      : 'Tidak Dapat Presensi',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: isWithinRadius
                                        ? Colors.green.shade700
                                        : Colors.red.shade700,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  isWithinRadius
                                      ? 'Anda berada dalam radius yang diizinkan'
                                      : 'Anda berada di luar radius yang diizinkan',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Action Buttons
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          // Refresh Location Button
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: IconButton(
                              onPressed: controller.getCurretLocation,
                              icon: Icon(
                                Icons.my_location_rounded,
                                color: Colors.blue.shade600,
                              ),
                              iconSize: 24,
                            ),
                          ),

                          const SizedBox(width: 12),

                          // Presensi Hadir Button
                          Expanded(
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isWithinRadius
                                      ? Colors.green.shade600
                                      : Colors.grey.shade400,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  elevation: isWithinRadius ? 4 : 0,
                                ),
                                onPressed: isWithinRadius
                                    ? controller.presensiHadir
                                    : null,
                                icon: Icon(Icons.fingerprint_rounded, size: 20),
                                label: const Text(
                                  'Presensi Hadir',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 12),

                          // Ajukan Izin Button
                          Expanded(
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange.shade500,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 4,
                              ),
                              onPressed: isWithinRadius
                                  ? () => controller.showIzinDialog(context)
                                  : null,
                              icon: const Icon(
                                Icons.edit_note_rounded,
                                size: 20,
                              ),
                              label: const Text(
                                'Ajukan Izin',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';

// import 'package:get/get.dart';
// import 'package:latlong2/latlong.dart';

// import '../controllers/presensi_controller.dart';

// class PresensiView extends GetView<PresensiController> {
//   const PresensiView({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       if (controller.isLoading.value) {
//         return const Center(child: CircularProgressIndicator());
//       }

//       final distance = Distance();
//       final double jarak = distance.as(
//         LengthUnit.Meter,
//         controller.currentLocation.value,
//         controller.schoolLocation,
//       );

//       final bool isWithinRadius = controller.isWithinRadius(100);

//       return Stack(
//         children: [
//           FlutterMap(
//             mapController: controller.mapController,
//             options: MapOptions(
//               initialCenter: controller.currentLocation.value,
//               initialZoom: 15.0,
//               minZoom: 15.0,
//               maxZoom: 18.0,
//               onTap: (_, _) => controller.popUpController.hideAllPopups(),
//             ),
//             children: [
//               TileLayer(
//                 urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
//                 userAgentPackageName: 'com.example.ujikom_polije',
//               ),
//               CircleLayer(
//                 circles: [
//                   CircleMarker(
//                     point: controller.schoolLocation,
//                     color: Color.fromRGBO(0, 128, 0, 0.5),
//                     borderStrokeWidth: 2,
//                     borderColor: Colors.green,
//                     radius: 100,
//                     useRadiusInMeter: true,
//                   ),
//                 ],
//               ),
//               PopupMarkerLayer(
//                 options: PopupMarkerLayerOptions(
//                   markers: controller.markers.toList(),
//                   popupDisplayOptions: PopupDisplayOptions(
//                     builder: (context, Marker marker) => Card(
//                       child: Padding(
//                         padding: EdgeInsets.all(8.0),
//                         child: Text(
//                           'Lokasi Anda saat ini',
//                           style: TextStyle(fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           SafeArea(
//             child: Column(
//               children: [
//                 const SizedBox(height: 20),
//                 Card(
//                   margin: const EdgeInsets.symmetric(horizontal: 16.0),
//                   elevation: 4,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12.0),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(12.0),
//                     child: Text(
//                       'Jarak Anda ke Polije: ${jarak.toStringAsFixed(2)} meter',
//                       style: TextStyle(fontSize: 16),
//                     ),
//                   ),
//                 ),
//                 const Spacer(),

//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const SizedBox(width: 16),
//                     FloatingActionButton(
//                       onPressed: controller.getCurretLocation,
//                       heroTag: 'Refresh',
//                       backgroundColor: Colors.blue,
//                       child: const Icon(Icons.my_location),
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         ElevatedButton.icon(
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: isWithinRadius
//                                 ? Colors.green
//                                 : Colors.grey,
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 16,
//                               vertical: 12,
//                             ),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                           ),
//                           onPressed: isWithinRadius
//                               ? controller.presensiHadir
//                               : null,
//                           icon: const Icon(
//                             Icons.fingerprint,
//                             color: Colors.white,
//                           ),
//                           label: const Text(
//                             'Presensi Hadir',
//                             style: TextStyle(color: Colors.white),
//                           ),
//                         ),
//                         ElevatedButton.icon(
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.orange,
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 16,
//                               vertical: 12,
//                             ),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                           ),
//                           onPressed: () => controller.showIzinDialog(context),
//                           icon: const Icon(
//                             Icons.edit_note,
//                             color: Colors.white,
//                           ),
//                           label: const Text(
//                             'Ajukan Izin',
//                             style: TextStyle(color: Colors.white),
//                           ),
//                         ),
//                       ],
//                     ),
//                     // ElevatedButton.icon(
//                     //   style: ElevatedButton.styleFrom(
//                     //     backgroundColor: isWithinRadius
//                     //         ? Colors.green
//                     //         : Colors.red,
//                     //     padding: const EdgeInsets.symmetric(
//                     //       horizontal: 20,
//                     //       vertical: 12,
//                     //     ),
//                     //     shape: RoundedRectangleBorder(
//                     //       borderRadius: BorderRadius.circular(12),
//                     //     ),
//                     //   ),
//                     //   onPressed: isWithinRadius
//                     //       ? () {
//                     //           print('Presensi Berhasil');
//                     //         }
//                     //       : null,
//                     //   label: const Text(
//                     //     'Presensi',
//                     //     style: TextStyle(color: Colors.white),
//                     //   ),
//                     //   icon: const Icon(Icons.fingerprint, color: Colors.white),
//                     // ),
//                   ],
//                 ),
//                 const SizedBox(height: 16),
//               ],
//             ),
//           ),
//           const SizedBox(height: 16),
//         ],
//       );
//     });
//   }
// }
