import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:ai_chat_kit/ai_chat_kit.dart';
import 'firebase_options.dart';
import 'theme.dart';
import 'services/api_key_service.dart';
import 'screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load saved or default Groq API key
  await ApiKeyService.load();

  const revenueCatKey = String.fromEnvironment(
    'REVENUECAT_KEY',
    defaultValue: 'test_PLACEHOLDER',
  );

  // Initialize AI chat SDK with valid Groq model
  AiChatSdk.initialize(
    config: AiChatConfig(
      baseUrl: 'https://api.groq.com/openai/v1',
      model: 'llama-3.3-70b-versatile',
      apiKey: ApiKeyService.groqKey,
      provider: LlmProvider.openAiCompatible,
      temperature: 0.7,
    ),
    aiContext: const AiContext(
      appName: 'Out Loud',
      description:
          'A warm, empathetic listener for people sharing their feelings anonymously.',
    ),
  );

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseAuth.instance.signInAnonymously();

  await Purchases.setLogLevel(LogLevel.debug);
  await Purchases.configure(
    PurchasesConfiguration(revenueCatKey),
  );

  runApp(const OutLoudApp());
}

class OutLoudApp extends StatelessWidget {
  const OutLoudApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Out Loud',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: const SplashScreen(),
    );
  }
}
