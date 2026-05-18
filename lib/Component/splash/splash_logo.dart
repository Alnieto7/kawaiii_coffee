import 'package:flutter/material.dart';
import 'package:kawaiii_coffee/Component/app_colors.dart';

class SplashLogo extends StatelessWidget {
  const SplashLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      height: 140,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.backgroundWhite,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowDark,
            blurRadius: 40,
            offset: const Offset(0, 16),
          ),
          BoxShadow(
            color: AppColors.backgroundWhite.withOpacity(0.06),
            blurRadius: 0,
            spreadRadius: 4,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Image.asset(
          'assets/images/kawaiii_logo.png',
          errorBuilder: (context, error, stack) => const _LogoFallback(),
        ),
      ),
    );
  }
}

class _LogoFallback extends StatelessWidget {
  const _LogoFallback();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'K',
          style: TextStyle(
            fontFamily: 'Georgia',
            fontSize: 48,
            fontWeight: FontWeight.w700,
            color: AppColors.secondary,
          ),
        ),
        Container(
          width: 80,
          height: 2,
          color: AppColors.secondary,
        ),
        const Text(
          'awaiii',
          style: TextStyle(
            fontFamily: 'Georgia',
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppColors.secondary,
          ),
        ),
      ],
    );
  }
}