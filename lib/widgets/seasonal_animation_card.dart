import 'package:flutter/material.dart';
import '../theme.dart';
import 'calm_illustration.dart';

/// Dedicated Seasonal Animation Showcase Box — clean, peaceful live canvas.
class SeasonalAnimationCard extends StatelessWidget {
  final Season season;
  const SeasonalAnimationCard({super.key, required this.season});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.lavender.withValues(alpha: 0.18),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Live Animated Canvas
          CalmIllustration(
            height: 165,
            season: season,
          ),

          // Top Seasonal Badge Tag
          Positioned(
            top: 12,
            left: 14,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.85),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    SeasonHelper.getSeasonIcon(season),
                    size: 14,
                    color: AppColors.sage,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _getSeasonalTagline(season),
                    style: AppText.caption.copyWith(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getSeasonalTagline(Season s) {
    switch (s) {
      case Season.spring:
        return 'Spring Blossom';
      case Season.summer:
        return 'Summer Solstice';
      case Season.autumn:
        return 'Autumn Golden Hour';
      case Season.winter:
        return 'Winter Stillness';
    }
  }
}
