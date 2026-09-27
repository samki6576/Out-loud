import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import '../theme.dart';
import '../widgets/calm_illustration.dart';
import '../widgets/out_loud_logo.dart';

class PaywallScreen extends StatefulWidget {
  final Season? season;
  const PaywallScreen({super.key, this.season});

  @override
  State<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends State<PaywallScreen> {
  Offerings? _offerings;
  bool _loading = false;
  int _selectedPlanIndex = 1; // Default to Yearly Best Value

  @override
  void initState() {
    super.initState();
    _loadOfferings();
  }

  Future<void> _loadOfferings() async {
    try {
      final offerings = await Purchases.getOfferings();
      if (mounted) {
        setState(() {
          _offerings = offerings;
        });
      }
    } catch (_) {}
  }

  Future<void> _purchase(Package package) async {
    setState(() => _loading = true);
    try {
      await Purchases.purchase(PurchaseParams.package(package));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Welcome to Out Loud+! ✨')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Purchase failed: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _handleFallbackPurchase(String planTitle, String price) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Subscribed to $planTitle ($price) in Demo Mode ✨'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final activeSeason = widget.season ?? SeasonHelper.getCurrentSeason();
    final currentOffering = _offerings?.current;
    final realPackages = currentOffering?.availablePackages ?? [];

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
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CalmIllustration(height: 150, season: activeSeason),
                const SizedBox(height: 16),

                // Hero Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const OutLoudLogo(size: 34, animate: false),
                    const SizedBox(width: 10),
                    Text(
                      'Out Loud+',
                      style: AppText.h1.copyWith(fontSize: 28),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'More depth, more care,\nfor the moments that matter.',
                  style: AppText.bodyMuted,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // Feature Highlights
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

                Text(
                  'Choose Your Plan',
                  style: AppText.h3,
                ),
                const SizedBox(height: 12),

                // Pricing Options (Real RevenueCat packages or Fallback Store Tiers)
                if (realPackages.isNotEmpty)
                  ...List.generate(realPackages.length, (i) {
                    final pkg = realPackages[i];
                    final isSelected = _selectedPlanIndex == i;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _PricingOptionCard(
                        title: pkg.storeProduct.title,
                        price: pkg.storeProduct.priceString,
                        subtitle: pkg.storeProduct.description,
                        isSelected: isSelected,
                        badge: pkg.packageType == PackageType.annual
                            ? 'BEST VALUE — SAVE 45%'
                            : null,
                        onTap: () {
                          setState(() => _selectedPlanIndex = i);
                        },
                      ),
                    );
                  })
                else ...[
                  // Fallback Demo Pricing Tiers
                  _PricingOptionCard(
                    title: 'Yearly Access',
                    price: '\$19.99 / year',
                    subtitle: 'Just \$1.66 / month — Billed annually',
                    badge: 'MOST POPULAR — SAVE 45%',
                    isSelected: _selectedPlanIndex == 1,
                    onTap: () => setState(() => _selectedPlanIndex = 1),
                  ),
                  const SizedBox(height: 10),
                  _PricingOptionCard(
                    title: 'Monthly Access',
                    price: '\$2.99 / month',
                    subtitle: 'Cancel or pause anytime',
                    isSelected: _selectedPlanIndex == 0,
                    onTap: () => setState(() => _selectedPlanIndex = 0),
                  ),
                  const SizedBox(height: 10),
                  _PricingOptionCard(
                    title: 'Lifetime Access',
                    price: '\$49.99 one-time',
                    subtitle: 'Pay once, keep forever',
                    isSelected: _selectedPlanIndex == 2,
                    onTap: () => setState(() => _selectedPlanIndex = 2),
                  ),
                ],

                const SizedBox(height: 20),

                // Main Subscription Button
                ElevatedButton(
                  onPressed: _loading
                      ? null
                      : () {
                          if (realPackages.isNotEmpty &&
                              _selectedPlanIndex < realPackages.length) {
                            _purchase(realPackages[_selectedPlanIndex]);
                          } else {
                            final fallbackTitles = [
                              'Monthly Access',
                              'Yearly Access',
                              'Lifetime Access'
                            ];
                            final fallbackPrices = [
                              '\$2.99/mo',
                              '\$19.99/yr',
                              '\$49.99'
                            ];
                            _handleFallbackPurchase(
                              fallbackTitles[_selectedPlanIndex],
                              fallbackPrices[_selectedPlanIndex],
                            );
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: _loading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Continue with Out Loud+',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                ),

                const SizedBox(height: 12),
                Text(
                  'Cancel anytime. Free tier stays free forever.',
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

class _PricingOptionCard extends StatelessWidget {
  final String title;
  final String price;
  final String subtitle;
  final String? badge;
  final bool isSelected;
  final VoidCallback onTap;

  const _PricingOptionCard({
    required this.title,
    required this.price,
    required this.subtitle,
    this.badge,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.sageLight.withValues(alpha: 0.5)
                : AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? AppColors.sage : AppColors.border,
              width: isSelected ? 2.0 : 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.lavender
                    .withValues(alpha: isSelected ? 0.18 : 0.06),
                blurRadius: isSelected ? 12 : 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              // Radio selection indicator
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? AppColors.sage : Colors.transparent,
                  border: Border.all(
                    color: isSelected ? AppColors.sage : AppColors.textMuted,
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? const Icon(
                        Icons.check,
                        size: 14,
                        color: Colors.white,
                      )
                    : null,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (badge != null) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        margin: const EdgeInsets.only(bottom: 4),
                        decoration: BoxDecoration(
                          color: AppColors.sage,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          badge!,
                          style: const TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                    Text(
                      title,
                      style: AppText.body.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: AppText.caption.copyWith(fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Text(
                price,
                style: AppText.h3.copyWith(
                  fontSize: 16,
                  color: AppColors.sage,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
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
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: softCard(),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, size: 20, color: color),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppText.body.copyWith(fontWeight: FontWeight.w600),
                  ),
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
