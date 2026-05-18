import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'splash_logo.dart';
import 'splash_brand_text.dart';
import 'splash_loader.dart';

class SplashContent extends StatefulWidget {
  final String nextRoute;

  const SplashContent({
    super.key,
    this.nextRoute = '/loginpage',
  });

  @override
  State<SplashContent> createState() => _SplashContentState();
}

class _SplashContentState extends State<SplashContent>
    with TickerProviderStateMixin {
  late final AnimationController _fadeController;
  late final AnimationController _slideController;
  late final AnimationController _loaderController;

  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;
  late final Animation<double> _loaderAnim;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _startSequence();
  }

  void _initAnimations() {
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _loaderController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    _fadeAnim = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );

    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _loaderAnim = CurvedAnimation(
      parent: _loaderController,
      curve: Curves.easeInOut,
    );
  }

  void _startSequence() {
    Future.delayed(const Duration(milliseconds: 200), () {
      if (!mounted) return;
      _fadeController.forward();
      _slideController.forward();
    });

    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      _loaderController.forward();
    });

    Timer(const Duration(seconds: 3), () {
      if (!mounted) return;
      Get.offAllNamed(widget.nextRoute);
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _loaderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: FadeTransition(
            opacity: _fadeAnim,
            child: SlideTransition(
              position: _slideAnim,
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SplashLogo(),
                  SizedBox(height: 28),
                  SplashBrandText(),
                ],
              ),
            ),
          ),
        ),
        SplashLoader(animation: _loaderAnim),
      ],
    );
  }
}