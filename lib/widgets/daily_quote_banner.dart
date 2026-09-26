import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';

/// Formatted as a collapsible handwritten physical paper note page dropdown.
class DailyQuoteBanner extends StatefulWidget {
  const DailyQuoteBanner({super.key});

  @override
  State<DailyQuoteBanner> createState() => _DailyQuoteBannerState();
}

class _DailyQuoteBannerState extends State<DailyQuoteBanner> {
  static const List<String> _quotes = [
    "Take a deep breath. You are doing better than you think.",
    "It's okay to feel whatever you're feeling right now.",
    "Peace begins with a single moment of quiet.",
    "Your story matters, even the unwritten parts.",
    "You don't have to carry everything all at once.",
    "Give yourself grace for how far you've come.",
    "Softness is not weakness; it is quiet strength.",
    "Even the stormiest clouds eventually clear.",
    "In the middle of noise, find your quiet corner.",
    "Every step forward, no matter how small, counts.",
  ];

  late int _currentIndex;
  bool _isExpanded = false; // Hidden/Collapsed by default

  @override
  void initState() {
    super.initState();
    _currentIndex = Random().nextInt(_quotes.length);
  }

  void _nextQuote() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % _quotes.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: _isExpanded ? -0.012 : 0.0, // Paper tilt when open
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => setState(() => _isExpanded = !_isExpanded),
          borderRadius: BorderRadius.circular(16),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: _isExpanded ? 16 : 10,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFDF5), // Parchment paper tint
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE8E2D5), width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: _isExpanded ? 0.07 : 0.04),
                  blurRadius: _isExpanded ? 12 : 6,
                  offset: Offset(0, _isExpanded ? 5 : 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top Paper Bar Header
                Row(
                  children: [
                    Container(
                      width: 24,
                      height: 10,
                      decoration: BoxDecoration(
                        color: AppColors.sageLight.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'DAILY THOUGHT 💭',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.1,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 6),
                    if (!_isExpanded)
                      Text(
                        '— Tap to read reflection',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textMuted,
                        ),
                      ),
                    const Spacer(),
                    if (_isExpanded) ...[
                      InkWell(
                        onTap: _nextQuote,
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          child: Row(
                            children: [
                              Icon(
                                Icons.auto_stories_rounded,
                                size: 13,
                                color: AppColors.textSecondary.withValues(alpha: 0.8),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Turn page',
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                    ],
                    AnimatedRotation(
                      turns: _isExpanded ? 0.5 : 0.0,
                      duration: const Duration(milliseconds: 300),
                      child: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: AppColors.textSecondary,
                        size: 20,
                      ),
                    ),
                  ],
                ),

                // Expanded Handwritten Note Text
                AnimatedCrossFade(
                  duration: const Duration(milliseconds: 300),
                  crossFadeState: _isExpanded
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  firstChild: const SizedBox.shrink(),
                  secondChild: Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      transitionBuilder: (child, anim) => FadeTransition(
                        opacity: anim,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, 0.12),
                            end: Offset.zero,
                          ).animate(anim),
                          child: child,
                        ),
                      ),
                      child: Text(
                        '“${_quotes[_currentIndex]}”',
                        key: ValueKey<int>(_currentIndex),
                        style: GoogleFonts.caveat(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF2C2C3A),
                          height: 1.25,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
