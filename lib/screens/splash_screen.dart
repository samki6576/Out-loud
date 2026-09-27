import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/calm_illustration.dart';
import '../widgets/out_loud_logo.dart';
import 'home_screen.dart';

/// Animated Splash Screen featuring the custom OutLoudLogo emblem.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInCubic,
    );

    _controller.forward();

    // Auto-navigate to HomeScreen after 2.2 seconds
    Future.delayed(const Duration(milliseconds: 2400), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          CalmPageRoute(page: const HomeScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentSeason = SeasonHelper.getCurrentSeason();

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: AppGradients.getGradientForSeason(currentSeason),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(),

              // Centered OutLoudLogo Badge with Scale & Fade Animation
              FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const OutLoudLogo(size: 110),
                      const SizedBox(height: 28),
                      Text(
                        'Out Loud',
                        style: AppText.h1.copyWith(
                          fontSize: 36,
                          letterSpacing: -0.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'You\'re not alone in this.',
                        style: AppText.bodyMuted.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(),

              // Live Animated Seasonal Canvas
              CalmIllustration(
                height: 180,
                season: currentSeason,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
