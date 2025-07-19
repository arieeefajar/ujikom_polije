import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:ujikom_polije/app/data/providers/presensi_provider.dart';
import 'package:ujikom_polije/app/modules/history/views/history_view.dart';
import 'package:ujikom_polije/app/modules/home/views/dashboard_view.dart';
import 'package:ujikom_polije/app/modules/presensi/views/presensi_view.dart';

class HomeController extends GetxController {
  // Existing properties
  final curretIndex = 0.obs;
  final List<String> pagesName = ['Dashboard', 'Presensi', 'Riwayat'];
  final List<Widget> pages = [
    const DashboardView(),
    const PresensiView(),
    const HistoryView(),
  ];
  final presensiProvider = Get.find<PresensiProvider>();

  // Dashboard properties
  final currentTime = DateTime.now().obs;
  final attendanceStatus = 'Belum Check In'.obs;
  final statusColor = Colors.red.obs;
  final statusBgColor = Colors.red.shade50.obs;
  final statusBorderColor = Colors.red.shade200.obs;
  final statusText = 'Belum Hadir'.obs;

  @override
  void onInit() {
    super.onInit();
    _startClock();
    _checkTodayAttendance();
  }

  @override
  void onClose() {
    // Clean up if needed
    super.onClose();
  }

  // Navigation
  void changePage(int index) {
    curretIndex.value = index;
  }

  // Clock functionality
  void _startClock() {
    ever(curretIndex, (_) {
      if (curretIndex.value == 0) {
        _updateTime();
      }
    });
    _updateTime();
  }

  void _updateTime() {
    currentTime.value = DateTime.now();
    // Update every second when on dashboard
    if (curretIndex.value == 0) {
      Future.delayed(const Duration(seconds: 1), () {
        if (curretIndex.value == 0) {
          _updateTime();
        }
      });
    }
  }

  // Date formatting
  String getCurrentDate() {
    final now = DateTime.now();
    final days = [
      'Minggu',
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
    ];
    final months = [
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

    return '${days[now.weekday % 7]}, ${now.day} ${months[now.month - 1]} ${now.year}';
  }

  String getGreeting() {
    final hour = DateTime.now().hour;

    if (hour >= 5 && hour < 11) {
      return 'Selamat Pagi';
    } else if (hour >= 11 && hour < 15) {
      return 'Selamat Siang';
    } else if (hour >= 15 && hour < 18) {
      return 'Selamat Sore';
    } else {
      return 'Selamat Malam';
    }
  }

  String getFormattedTime() {
    return '${currentTime.value.hour.toString().padLeft(2, '0')}:'
        '${currentTime.value.minute.toString().padLeft(2, '0')}:'
        '${currentTime.value.second.toString().padLeft(2, '0')}';
  }

  IconData getIconForPage(int index) {
    switch (index) {
      case 0:
        return Icons.dashboard_rounded;
      case 1:
        return Icons.access_time_rounded;
      case 2:
        return Icons.history_rounded;
      default:
        return Icons.dashboard_rounded;
    }
  }

  String getSubtitleForPage(int index) {
    switch (index) {
      case 0:
        return 'Selamat datang di dashboard utama';
      case 1:
        return 'Catat kehadiran Anda hari ini';
      case 2:
        return 'Lihat catatan kehadiran Anda';
      default:
        return 'Selamat datang';
    }
  }

  // Attendance status check
  void _checkTodayAttendance() async {
    try {
      final response = await presensiProvider.getStatusHariIni();

      if (response.statusCode == 200 && response.body['success'] == true) {
        final status = response.body['status'];

        if (status == 'hadir') {
          attendanceStatus.value = 'Sudah Check In';
          statusColor.value = Colors.green;
          statusBgColor.value = Colors.green.shade50;
          statusBorderColor.value = Colors.green.shade200;
          statusText.value = 'Hadir';
        } else {
          attendanceStatus.value = 'Belum Check In';
          statusColor.value = Colors.red;
          statusBgColor.value = Colors.red.shade50;
          statusBorderColor.value = Colors.red.shade200;
          statusText.value = 'Belum Hadir';
        }
      } else {
        _showStatusError();
      }
    } catch (e) {
      _showStatusError();
    }
  }

  void _showStatusError() {
    attendanceStatus.value = 'Gagal Cek Status';
    statusColor.value = Colors.orange;
    statusBgColor.value = Colors.orange.shade50;
    statusBorderColor.value = Colors.orange.shade200;
    statusText.value = 'Error';
  }

  // Profile dropdown actions
  void onProfileMenuSelected(String value) {
    switch (value) {
      case 'logout':
        _showLogoutDialog();
        break;
      default:
        break;
    }
  }

  // Dialog methods
  void _showLogoutDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Konfirmasi Logout'),
        content: const Text('Apakah Anda yakin ingin keluar dari aplikasi?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              Get.back();
              _performLogout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  // Logout functionality
  void _performLogout() {
    Get.snackbar(
      'Logout',
      'Anda telah keluar dari aplikasi',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.shade100,
      colorText: Colors.red.shade800,
    );

    // Example: Navigate to login page
    // Get.offAllNamed('/login');
  }

  void refreshAttendanceStatus() {
    _checkTodayAttendance();
  }

  void updateCheckInStatus() {
    attendanceStatus.value = 'Sudah Check In';
    statusColor.value = Colors.green;
    statusBgColor.value = Colors.green.shade50;
    statusBorderColor.value = Colors.green.shade200;
    statusText.value = 'Hadir';

    Get.snackbar(
      'Berhasil',
      'Check-in berhasil dicatat',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.shade100,
      colorText: Colors.green.shade800,
    );
  }

  void updateCheckOutStatus() {
    attendanceStatus.value = 'Sudah Check Out';
    statusColor.value = Colors.blue;
    statusBgColor.value = Colors.blue.shade50;
    statusBorderColor.value = Colors.blue.shade200;
    statusText.value = 'Selesai';

    Get.snackbar(
      'Berhasil',
      'Check-out berhasil dicatat',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue.shade100,
      colorText: Colors.blue.shade800,
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:ujikom_polije/app/modules/history/views/history_view.dart';
// import 'package:ujikom_polije/app/modules/presensi/views/presensi_view.dart';

// class HomeController extends GetxController {
//   final RxInt curretIndex = 0.obs;
//   @override
//   void onInit() {
//     super.onInit();
//   }

//   final List<Widget> pages = [
//     const Center(
//       child: Text(
//         'Selamat Datang',
//         style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//       ),
//     ),
//     PresensiView(),
//     HistoryView(),
//   ];

//   void changePage(int index) {
//     curretIndex.value = index;
//   }
// }
