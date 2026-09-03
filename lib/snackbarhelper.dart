import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kawaiii_coffee/Component/app_colors.dart';

class SnackbarHelper {
  SnackbarHelper._();

  static void error(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColors.error,
      colorText: AppColors.textOnPrimary,
      icon: const Icon(Icons.error_outline, color: AppColors.textOnPrimary),
      borderRadius: 12,
      margin: const EdgeInsets.all(12),
      duration: const Duration(seconds: 4),
      isDismissible: true,
    );
  }

  static void success(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColors.success,
      colorText: AppColors.textOnPrimary,
      icon: const Icon(Icons.check_circle_outline, color: AppColors.textOnPrimary),
      borderRadius: 12,
      margin: const EdgeInsets.all(12),
      duration: const Duration(seconds: 3),
      isDismissible: true,
    );
  }

  static void warning(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColors.primary,
      colorText: AppColors.textOnPrimary,
      icon: const Icon(Icons.warning_amber_outlined, color: AppColors.textOnPrimary),
      borderRadius: 12,
      margin: const EdgeInsets.all(12),
      duration: const Duration(seconds: 3),
      isDismissible: true,
    );
  }

  static void info(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColors.info,
      colorText: AppColors.textOnPrimary,
      icon: const Icon(Icons.info_outline, color: AppColors.textOnPrimary),
      borderRadius: 12,
      margin: const EdgeInsets.all(12),
      duration: const Duration(seconds: 3),
      isDismissible: true,
    );
  }
}