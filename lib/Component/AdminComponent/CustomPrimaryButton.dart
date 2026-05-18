import 'package:flutter/material.dart';
import 'package:kawaiii_coffee/Component/app_colors.dart';

class CustomPrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;

  const CustomPrimaryButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          disabledBackgroundColor: AppColors.primaryLight,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  color: AppColors.textOnPrimary,
                  strokeWidth: 2.5,
                ),
              )
            : Text(
                text,
                style: const TextStyle(
                  color: AppColors.textOnPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}