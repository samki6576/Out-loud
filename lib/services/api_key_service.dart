import 'package:shared_preferences/shared_preferences.dart';

class ApiKeyService {
  static const _prefKey = 'groq_api_key';
  static const _defaultGroqKey =
      'PLACEHOLDER' ;

  static String _cachedGroqKey = '';
  static String get groqKey =>
      _cachedGroqKey.isNotEmpty ? _cachedGroqKey : _defaultGroqKey;
  static bool get hasGroqKey => groqKey.isNotEmpty;

  static Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _cachedGroqKey = prefs.getString(_prefKey) ?? '';

    if (_cachedGroqKey.isEmpty) {
      const fromEnv = String.fromEnvironment('GROQ_API_KEY');
      if (fromEnv.isNotEmpty && fromEnv != 'gsk_PLACEHOLDER') {
        _cachedGroqKey = fromEnv;
        await prefs.setString(_prefKey, fromEnv);
      }
    }
  }

  static Future<void> saveGroqKey(String key) async {
    final trimmed = key.trim();
    _cachedGroqKey = trimmed;
    final prefs = await SharedPreferences.getInstance();
    if (trimmed.isEmpty) {
      await prefs.remove(_prefKey);
    } else {
      await prefs.setString(_prefKey, trimmed);
    }
  }

  static Future<void> clearGroqKey() => saveGroqKey('');
}
