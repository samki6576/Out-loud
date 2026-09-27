import 'package:flutter/material.dart';
import '../services/api_key_service.dart';
import '../theme.dart';
import '../widgets/out_loud_logo.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late TextEditingController _controller;
  bool _obscure = true;
  bool _saved = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: ApiKeyService.groqKey);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    await ApiKeyService.saveGroqKey(_controller.text);
    if (!mounted) return;
    setState(() => _saved = true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Saved. Restart the app to apply.'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _clear() async {
    await ApiKeyService.clearGroqKey();
    if (!mounted) return;
    _controller.clear();
    setState(() => _saved = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const OutLoudLogo(size: 26, animate: false),
            const SizedBox(width: 8),
            const Text('Settings'),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: AppGradients.background),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Groq API Key', style: AppText.h3),
                const SizedBox(height: 6),
                Text(
                  'Stored locally on this device. Get one free at '
                  'consolegroq.com/keys',
                  style: AppText.caption,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _controller,
                  obscureText: _obscure,
                  autocorrect: false,
                  enableSuggestions: false,
                  style: AppText.body,
                  decoration: InputDecoration(
                    hintText: 'gsk_...',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscure
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      onPressed: () =>
                          setState(() => _obscure = !_obscure),
                    ),
                  ),
                  onChanged: (_) => setState(() => _saved = false),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _controller.text.trim().isEmpty ? null : _save,
                  child: Text(_saved ? 'Saved ✓' : 'Save key'),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: _clear,
                  child: const Text('Clear key'),
                ),
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: softCard(),
                  child: Row(
                    children: [
                      Icon(
                        ApiKeyService.hasGroqKey
                            ? Icons.check_circle_outline
                            : Icons.error_outline,
                        color: ApiKeyService.hasGroqKey
                            ? AppColors.sage
                            : AppColors.danger,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          ApiKeyService.hasGroqKey
                              ? 'A key is saved on this device.'
                              : 'No key saved yet. AI features are disabled.',
                          style: AppText.caption.copyWith(
                            color: AppColors.textSecondary,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
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
