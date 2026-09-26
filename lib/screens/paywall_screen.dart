import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import '../theme.dart';
import '../widgets/calm_illustration.dart';

class PaywallScreen extends StatefulWidget {
  final Season? season;
  const PaywallScreen({super.key, this.season});

  @override
  State<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends State<PaywallScreen> {
  Offerings? _offerings;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadOfferings();
  }

  Future<void> _loadOfferings() async {
    try {
      final offerings = await Purchases.getOfferings();
      if (mounted) setState(() => _offerings = offerings);
    } catch (_) {}
  }

  Future<void> _purchase(Package package) async {
    setState(() => _loading = true);
    try {
      await Purchases.purchase(PurchaseParams.package(package));
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Purchase failed: $e')));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeSeason = widget.season ?? SeasonHelper.getCurrentSeason();
    final current = _offerings?.current;

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: AppGradients.getGradientForSeason(activeSeason),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CalmIllustration(height: 160, season: activeSeason),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/logo.jfif',
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.spa_rounded,
                            color: AppColors.sage,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Out Loud+',
                      style: AppText.h1.copyWith(fontSize: 28),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'More depth, more care,\nfor the moments that matter.',
                  style: AppText.bodyMuted,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 28),
                _Feature(
                  icon: Icons.chat_bubble_outline,
                  title: 'Longer replies',
                  subtitle: 'Say more than one sentence back',
                  color: AppColors.lavender,
                ),
                _Feature(
                  icon: Icons.favorite_border,
                  title: 'See who resonates',
                  subtitle: 'Know how many people feel the same',
                  color: AppColors.danger,
                ),
                _Feature(
                  icon: Icons.insights_outlined,
                  title: 'Private patterns',
                  subtitle: 'Understand your feelings over time',
                  color: AppColors.sage,
                ),
                const SizedBox(height: 24),
                if (current == null)
                  const Center(
                    child: CircularProgressIndicator(color: AppColors.sage),
                  )
                else
                  ...current.availablePackages.map(
                    (p) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: ElevatedButton(
                        onPressed: _loading ? null : () => _purchase(p),
                        child: Text(
                          '${p.storeProduct.title} — ${p.storeProduct.priceString}',
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 12),
                Text(
                  'Cancel anytime.\nThe free tier stays free forever.',
                  textAlign: TextAlign.center,
                  style: AppText.caption,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Feature extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  const _Feature({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: softCard(),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, size: 22, color: color),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: AppText.body
                          .copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: AppText.caption),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
