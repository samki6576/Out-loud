import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_key_service.dart';

class GroqService {
  static const _endpoint = 'https://api.groq.com/openai/v1/chat/completions';

  static Future<String> suggestReply(String noteText) async {
    final key = ApiKeyService.groqKey;
    if (key.isEmpty) return '';

    final body = jsonEncode({
      'model': 'openai/gpt-oss-120b',
      'messages': [
        {
          'role': 'system',
          'content':
              'You write one short, warm, human sentence in reply to someone '
              'sharing a feeling. No advice, no fixing. Just acknowledgment. '
              'Under 20 words. Never mention you are an AI.'
        },
        {'role': 'user', 'content': noteText},
      ],
      'temperature': 0.8,
      'max_tokens': 60,
    });

    final res = await http.post(
      Uri.parse(_endpoint),
      headers: {
        'Authorization': 'Bearer $key',
        'Content-Type': 'application/json',
      },
      body: body,
    );

    if (res.statusCode != 200) return '';
    final data = jsonDecode(res.body);
    return data['choices'][0]['message']['content'].toString().trim();
  }
}
