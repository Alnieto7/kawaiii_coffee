import 'package:flutter/material.dart';
import 'package:kawaiii_coffee/Component/app_colors.dart';

class SplashLoader extends StatelessWidget {
  final Animation<double> animation;

  const SplashLoader({
    super.key,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 60,
      left: 0,
      right: 0,
      child: Center(
        child: SizedBox(
          width: 100,
          child: AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: LinearProgressIndicator(
                  value: animation.value,
                  backgroundColor: AppColors.loaderTrack,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.primary,
                  ),
                  minHeight: 2,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}