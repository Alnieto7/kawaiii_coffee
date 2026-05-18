import 'package:flutter/material.dart';
import 'package:kawaiii_coffee/Component/app_colors.dart';
import 'package:kawaiii_coffee/Component/splash/splash_background.dart';
import 'package:kawaiii_coffee/Component/splash/splash_content.dart';


class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Stack(
        children: [
          SplashBackground(),
          SplashContent(nextRoute: '/loginpage'),
        ],
      ),
    );
  }
}