import 'package:flutter/material.dart';
import 'package:ai_chat_kit/ai_chat_kit.dart';
import '../models/note.dart';
import '../services/note_service.dart';
import '../services/crisis_detector.dart';
import '../services/groq_service.dart';
import '../theme.dart';
import '../widgets/daily_quote_banner.dart';
import '../widgets/seasonal_animation_card.dart';
import 'crisis_screen.dart';
import 'post_note_screen.dart';
import 'paywall_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Season _selectedSeason;

  @override
  void initState() {
    super.initState();
    _selectedSeason = SeasonHelper.getCurrentSeason();
  }

  void _cycleSeason() {
    setState(() {
      final nextIndex = (_selectedSeason.index + 1) % Season.values.length;
      _selectedSeason = Season.values[nextIndex];
    });
  }

  @override
  Widget build(BuildContext context) {
    final service = NoteService();

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          gradient: AppGradients.getGradientForSeason(_selectedSeason),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _Header(
                selectedSeason: _selectedSeason,
                onSeasonTap: _cycleSeason,
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 4, 16, 10),
                child: DailyQuoteBanner(),
              ),
              Expanded(
                child: StreamBuilder<List<Note>>(
                  stream: service.streamRecentNotes(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.sage,
                        ),
                      );
                    }
                    final notes = snapshot.data ?? [];
                    return ListView(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
                      children: [
                        // Dedicated Seasonal Animation Showcase Box
                        Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: SeasonalAnimationCard(
                            season: _selectedSeason,
                          ),
                        ),
                        if (notes.isEmpty)
                          _EmptyState(season: _selectedSeason)
                        else
                          ...List.generate(
                            notes.length,
                            (i) => Padding(
                              padding: const EdgeInsets.only(bottom: 14),
                              child: NoteCard(
                                note: notes[i],
                                service: service,
                                index: i,
                                season: _selectedSeason,
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.sage.withValues(alpha: 0.4),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          onPressed: () => Navigator.push(
            context,
            CalmPageRoute(page: PostNoteScreen(season: _selectedSeason)),
          ),
          label: const Text('Say it'),
          icon: const Icon(Icons.edit_outlined),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final Season selectedSeason;
  final VoidCallback onSeasonTap;

  const _Header({
    required this.selectedSeason,
    required this.onSeasonTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
      child: Row(
        children: [
          // App Logo
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.lavender.withValues(alpha: 0.25),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/logo.jfif',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: AppColors.sageLight,
                  child: const Icon(Icons.spa_rounded, color: AppColors.sage, size: 20),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              'Out Loud',
              style: AppText.h1.copyWith(fontSize: 22),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 6),

          // Seasonal Switcher Button
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onSeasonTap,
              borderRadius: BorderRadius.circular(18),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.surface.withValues(alpha: 0.85),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      SeasonHelper.getSeasonIcon(selectedSeason),
                      size: 14,
                      color: AppColors.sage,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      SeasonHelper.getSeasonName(selectedSeason),
                      style: AppText.caption.copyWith(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 5),

          _SoftIcon(
            icon: Icons.settings_outlined,
            onTap: () => Navigator.push(
              context,
              CalmPageRoute(page: const SettingsScreen()),
            ),
          ),
          const SizedBox(width: 5),
          _SoftIcon(
            icon: Icons.smart_toy_outlined,
            onTap: () => AiChatSdk.showChat(context),
          ),
          const SizedBox(width: 5),
          _SoftIcon(
            icon: Icons.auto_awesome_outlined,
            onTap: () => Navigator.push(
              context,
              CalmPageRoute(page: PaywallScreen(season: selectedSeason)),
            ),
          ),
        ],
      ),
    );
  }
}

class _SoftIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _SoftIcon({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppColors.lavender.withValues(alpha: 0.15),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(icon, size: 18, color: AppColors.textPrimary),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final Season season;
  const _EmptyState({required this.season});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 40),
      child: Column(
        children: [
          Text(
            'It\'s quiet here.',
            style: AppText.h1.copyWith(fontSize: 24),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            'Be the first to say\nwhat you\'ve been holding in.',
            style: AppText.bodyMuted,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: softCard(),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.sageLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.spa_outlined,
                    color: AppColors.sage,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    'Every feeling you share\nhelps someone else feel less alone.',
                    style: AppText.caption.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class NoteCard extends StatefulWidget {
  final Note note;
  final NoteService service;
  final int index;
  final Season season;
  const NoteCard({
    super.key,
    required this.note,
    required this.service,
    required this.index,
    required this.season,
  });

  @override
  State<NoteCard> createState() => _NoteCardState();
}

class _NoteCardState extends State<NoteCard>
    with SingleTickerProviderStateMixin {
  bool _crisisShown = false;
  bool _resonated = false;
  bool _isExpanded = false; // Accordion / Dropdown expansion state

  late AnimationController _ctrl;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600 + (widget.index * 80).clamp(0, 600)),
    );
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic);
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_crisisShown && CrisisDetector.isCrisis(widget.note.text)) {
      _crisisShown = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Navigator.push(
            context,
            CalmPageRoute(page: CrisisScreen(season: widget.season)),
          );
        }
      });
    }

    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.08),
          end: Offset.zero,
        ).animate(_fade),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            borderRadius: BorderRadius.circular(24),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.all(20),
              decoration: softCard(elevated: _isExpanded),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Row with Indicator, Time, and Dropdown Arrow
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.sage,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(_timeAgo(widget.note.createdAt),
                          style: AppText.caption),
                      const Spacer(),
                      if (!_isExpanded && widget.note.resonanceCount > 0) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.lavenderLight.withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${widget.note.resonanceCount} feel this',
                            style: AppText.caption.copyWith(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      AnimatedRotation(
                        turns: _isExpanded ? 0.5 : 0.0,
                        duration: const Duration(milliseconds: 300),
                        child: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: AppColors.textSecondary,
                          size: 22,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Note Text (Truncated when collapsed, Full when expanded)
                  AnimatedCrossFade(
                    duration: const Duration(milliseconds: 300),
                    crossFadeState: _isExpanded
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    firstChild: Text(
                      widget.note.text,
                      style: AppText.body.copyWith(fontSize: 16, height: 1.5),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    secondChild: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.note.text,
                          style: AppText.body.copyWith(fontSize: 16, height: 1.5),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            _ReactionButton(
                              icon: _resonated
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: _resonated
                                  ? AppColors.danger
                                  : AppColors.textSecondary,
                              label: _resonated
                                  ? 'You feel this'
                                  : '${widget.note.resonanceCount} feel this',
                              onTap: () {
                                if (_resonated) return;
                                setState(() => _resonated = true);
                                widget.service.resonate(widget.note.id);
                              },
                            ),
                            const Spacer(),
                            _ReactionButton(
                              icon: Icons.chat_bubble_outline,
                              color: AppColors.textSecondary,
                              label: widget.note.reply == null ? 'Reply' : 'Replied',
                              onTap: () => _showReplySheet(
                                context,
                                widget.service,
                                widget.note,
                              ),
                            ),
                          ],
                        ),
                        if (widget.note.reply != null) ...[
                          const SizedBox(height: 14),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: AppColors.lavenderLight.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.format_quote,
                                  size: 16,
                                  color: AppColors.lavender,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    widget.note.reply!,
                                    style: AppText.bodyMuted.copyWith(
                                      color: AppColors.textPrimary,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  void _showReplySheet(BuildContext context, NoteService service, Note note) {
    final controller = TextEditingController();
    bool suggesting = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                left: 20,
                right: 20,
                top: 12,
              ),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 18),
                      decoration: BoxDecoration(
                        color: AppColors.border,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  Text('Send one sentence', style: AppText.h3),
                  const SizedBox(height: 4),
                  Text('No names. No history. Just kindness.',
                      style: AppText.caption),
                  const SizedBox(height: 18),
                  TextField(
                    controller: controller,
                    maxLines: 3,
                    maxLength: 240,
                    style: AppText.body,
                    decoration: const InputDecoration(
                      hintText: 'Say something kind...',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: suggesting
                              ? const SizedBox(
                                  height: 16,
                                  width: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColors.sage,
                                  ),
                                )
                              : const Icon(Icons.auto_awesome, size: 18),
                          label: Text(suggesting ? 'Thinking…' : 'Suggest'),
                          onPressed: suggesting
                              ? null
                              : () async {
                                  setSheetState(() => suggesting = true);
                                  final s = await GroqService.suggestReply(
                                    note.text,
                                  );
                                  setSheetState(() => suggesting = false);
                                  if (s.isNotEmpty) controller.text = s;
                                },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            if (controller.text.trim().isEmpty) return;
                            await service.reply(
                              note.id,
                              controller.text.trim(),
                            );
                            if (context.mounted) Navigator.pop(context);
                          },
                          child: const Text('Send'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _ReactionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final VoidCallback onTap;
  const _ReactionButton({
    required this.icon,
    required this.color,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Row(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 6),
            Text(label, style: AppText.caption.copyWith(color: color)),
          ],
        ),
      ),
    );
  }
}
