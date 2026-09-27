import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/calm_illustration.dart';
import '../widgets/out_loud_logo.dart';

class CrisisScreen extends StatelessWidget {
  final Season? season;
  const CrisisScreen({super.key, this.season});

  @override
  Widget build(BuildContext context) {
    final activeSeason = season ?? SeasonHelper.getCurrentSeason();

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: AppGradients.getGradientForSeason(activeSeason),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CalmIllustration(height: 160, season: activeSeason),
                const SizedBox(height: 24),
                Row(
                  children: [
                    const OutLoudLogo(size: 32, animate: false),
                    const SizedBox(width: 10),
                    Text('You matter.', style: AppText.h1.copyWith(fontSize: 28)),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'What you\'re feeling is real, and you don\'t have to carry '
                  'it alone. Please reach out to someone trained to help.',
                  style: AppText.bodyMuted,
                ),
                const SizedBox(height: 24),
                _Helpline(region: 'Pakistan', number: 'Umang: 0311-7786264'),
                _Helpline(region: 'International', number: 'befrienders.org'),
                _Helpline(region: 'US', number: '988 Suicide & Crisis Lifeline'),
                _Helpline(region: 'UK', number: 'Samaritans: 116 123'),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('I understand'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Helpline extends StatelessWidget {
  final String region;
  final String number;
  const _Helpline({required this.region, required this.number});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: softCard(),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppColors.sageLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.phone_outlined,
                size: 20,
                color: AppColors.sage,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(region, style: AppText.label),
                  const SizedBox(height: 4),
                  Text(
                    number,
                    style: AppText.body.copyWith(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
