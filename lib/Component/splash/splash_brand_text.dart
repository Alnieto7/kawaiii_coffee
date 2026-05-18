import 'package:flutter/material.dart';
import 'package:kawaiii_coffee/Component/app_colors.dart';

class SplashBrandText extends StatelessWidget {
  const SplashBrandText({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Kawaiii Coffee',
          style: TextStyle(
            fontFamily: 'Georgia',
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: AppColors.textOnDark,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'EST. 2024  ·  SEMARANG',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w400,
            color: AppColors.splashSubtitle,
            letterSpacing: 4,
          ),
        ),
        const SizedBox(height: 20),
        Container(
          width: 40,
          height: 1,
          color: AppColors.splashDivider,
        ),
        const SizedBox(height: 20),
        const Text(
          'Every cup tells a story',
          style: TextStyle(
            fontFamily: 'Georgia',
            fontStyle: FontStyle.italic,
            fontSize: 13,
            color:  AppColors.splashTagline,
            letterSpacing: 0.4,
          ),
        ),
      ],
    );
  }
}