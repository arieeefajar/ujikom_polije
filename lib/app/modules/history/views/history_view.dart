import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ujikom_polije/app/data/models/presensi_riwayat_model.dart';
import '../controllers/history_controller.dart';

class HistoryView extends GetView<HistoryController> {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            // Content Area
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return _buildLoadingState();
                }

                if (controller.listRiwayat.isEmpty) {
                  return _buildEmptyState();
                }

                return _buildHistoryList();
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
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
            'Memuat riwayat presensi...',
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.grey.shade100, Colors.grey.shade50],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.inbox_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Belum ada data presensi',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Riwayat presensi Anda akan muncul di sini',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryList() {
    return RefreshIndicator(
      onRefresh: () async {
        controller.fetchRiwayat();
      },
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: controller.listRiwayat.length,
        itemBuilder: (context, index) {
          final item = controller.listRiwayat[index];
          return _buildHistoryCard(item, index);
        },
      ),
    );
  }

  Widget _buildHistoryCard(PresensiRiwayatModel item, int index) {
    Color statusColor;
    IconData statusIcon;
    Color statusBgColor;

    switch (item.status.toLowerCase()) {
      case 'hadir':
        statusColor = Colors.green.shade600;
        statusIcon = Icons.check_circle_rounded;
        statusBgColor = Colors.green.shade50;
        break;
      case 'izin':
        statusColor = Colors.orange.shade600;
        statusIcon = Icons.info_rounded;
        statusBgColor = Colors.orange.shade50;
        break;
      default:
        statusColor = Colors.red.shade600;
        statusIcon = Icons.cancel_rounded;
        statusBgColor = Colors.red.shade50;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        elevation: 0,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withAlpha(25),
                spreadRadius: 0,
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              // Tambahkan aksi jika diperlukan
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Status Icon with Background
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: statusBgColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(statusIcon, color: statusColor, size: 24),
                  ),

                  const SizedBox(width: 16),

                  // Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                controller.formatDate(item.tanggal),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: statusBgColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                item.status,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: statusColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time_rounded,
                              size: 14,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              item.jam,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Arrow Icon
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                    color: Colors.grey[400],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';

// import 'package:get/get.dart';

// import '../controllers/history_controller.dart';

// class HistoryView extends GetView<HistoryController> {
//   const HistoryView({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Obx(() {
//         if (controller.isLoading.value) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         if (controller.listRiwayat.isEmpty) {
//           return const Center(child: Text("Belum ada data presensi."));
//         }

//         return ListView.builder(
//           itemCount: controller.listRiwayat.length,
//           itemBuilder: (context, index) {
//             final item = controller.listRiwayat[index];
//             return ListTile(
//               leading: Icon(
//                 item.status == "Hadir"
//                     ? Icons.check_circle
//                     : item.status == "Izin"
//                     ? Icons.info
//                     : Icons.cancel,
//                 color: item.status == "Hadir"
//                     ? Colors.green
//                     : item.status == "Izin"
//                     ? Colors.orange
//                     : Colors.red,
//               ),
//               title: Text(item.tanggal),
//               subtitle: Text(item.status),
//             );
//           },
//         );
//       }),
//     );
//   }
// }
