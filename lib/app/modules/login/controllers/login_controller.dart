import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ujikom_polije/app/data/models/Auth/login_request_model.dart';
import 'package:ujikom_polije/app/data/providers/auth_provider.dart';
import 'package:ujikom_polije/app/routes/app_pages.dart';

class LoginController extends GetxController {
  final authProvider = Get.find<AuthProvider>();
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final storage = GetStorage();

  var isPasswordVisible = false.obs;
  var isLoading = false.obs;

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email tidak boleh kosong';
    }
    if (!GetUtils.isEmail(value)) {
      return 'Format email tidak valid';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password tidak boleh kosong';
    }
    if (value.length < 6) {
      return 'Password minimal 6 karakter';
    }
    return null;
  }

  void login() async {
    if (formKey.currentState!.validate()) {
      isLoading.value = true;

      final loginRequest = LoginRequestModel(
        email: emailController.text,
        password: passwordController.text,
      );

      try {
        final response = await authProvider.login(loginRequest);

        if (response != null && response.status) {
          storage.write('token', response.token);
          storage.write('user', response.user);

          Get.snackbar(
            'Success',
            response.message,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 3),
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            borderRadius: 8,
            dismissDirection: DismissDirection.horizontal,
            animationDuration: const Duration(milliseconds: 300),
            icon: const Icon(Icons.check, color: Colors.white),
          );
          Get.toNamed(Routes.HOME);
        } else {
          Get.snackbar(
            'Gagal',
            'Login gagal, priksa email atau password Anda',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 3),
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            borderRadius: 8,
            dismissDirection: DismissDirection.horizontal,
            animationDuration: const Duration(milliseconds: 300),
            icon: const Icon(Icons.error, color: Colors.white),
          );
        }
      } catch (e) {
        Get.snackbar('Error', 'Terjadi kesalahan: $e');
      } finally {
        isLoading.value = false;
      }
    }
  }
}
