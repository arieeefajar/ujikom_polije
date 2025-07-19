import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/history_controller.dart';

class HistoryView extends GetView<HistoryController> {
  const HistoryView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Presensi'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.listRiwayat.isEmpty) {
          return const Center(child: Text("Belum ada data presensi."));
        }

        return ListView.builder(
          itemCount: controller.listRiwayat.length,
          itemBuilder: (context, index) {
            final item = controller.listRiwayat[index];
            return ListTile(
              leading: Icon(
                item.status == "Hadir"
                    ? Icons.check_circle
                    : item.status == "Izin"
                    ? Icons.info
                    : Icons.cancel,
                color: item.status == "Hadir"
                    ? Colors.green
                    : item.status == "Izin"
                    ? Colors.orange
                    : Colors.red,
              ),
              title: Text(item.tanggal),
              subtitle: Text(item.status),
            );
          },
        );
      }),
    );
  }
}
