import 'package:flutter/material.dart';
import '../services/note_service.dart';
import '../theme.dart';
import '../widgets/calm_illustration.dart';
import '../widgets/out_loud_logo.dart';

class PostNoteScreen extends StatefulWidget {
  final Season? season;
  const PostNoteScreen({super.key, this.season});

  @override
  State<PostNoteScreen> createState() => _PostNoteScreenState();
}

class _PostNoteScreenState extends State<PostNoteScreen> {
  final _controller = TextEditingController();
  final _service = NoteService();
  bool _posting = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeSeason = widget.season ?? SeasonHelper.getCurrentSeason();
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      backgroundColor: AppColors.bg,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const OutLoudLogo(size: 26, animate: false),
            const SizedBox(width: 8),
            Text('Say it out loud', style: AppText.h3),
          ],
        ),
      ),
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: AppGradients.getGradientForSeason(activeSeason),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(24, 0, 24, bottomInset > 0 ? bottomInset + 16 : 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (bottomInset == 0) ...[
                  CalmIllustration(height: 140, season: activeSeason),
                  const SizedBox(height: 16),
                ],
                Text(
                  'What do you\nneed to say?',
                  style: AppText.h1.copyWith(fontSize: 28),
                ),
                const SizedBox(height: 6),
                Text(
                  'Whatever it is, it\'s allowed here.',
                  style: AppText.bodyMuted,
                ),
                const SizedBox(height: 18),

                // Text Input Container
                Container(
                  height: bottomInset > 0 ? 160 : 200,
                  padding: const EdgeInsets.all(20),
                  decoration: softCard(),
                  child: TextField(
                    controller: _controller,
                    maxLines: null,
                    expands: true,
                    maxLength: 500,
                    autofocus: true,
                    style: AppText.body.copyWith(fontSize: 17, height: 1.6),
                    decoration: InputDecoration(
                      hintText: 'Start typing your feelings...',
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      filled: false,
                      counterStyle: AppText.caption,
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                const SizedBox(height: 14),

                Row(
                  children: [
                    const Icon(
                      Icons.lock_outline,
                      size: 16,
                      color: AppColors.textMuted,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Disappears in 24 hours. Anonymous & safe.',
                        style: AppText.caption,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                ElevatedButton(
                  onPressed: _posting || _controller.text.trim().isEmpty
                      ? null
                      : _post,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    disabledBackgroundColor: AppColors.surfaceSoft,
                    disabledForegroundColor: AppColors.textMuted,
                  ),
                  child: _posting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Say it'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _post() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() => _posting = true);
    await _service.postNote(text);
    if (mounted) Navigator.pop(context);
  }
}
