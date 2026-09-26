# Out Loud

> **A quiet place to say the thing you can't say anywhere else.**

[![Built with Flutter](https://img.shields.io/badge/Built%20with-Flutter-02569B?logo=flutter)](https://flutter.dev)
[![Firebase](https://img.shields.io/badge/Backend-Firebase-FFCA28?logo=firebase)](https://firebase.google.com)
[![RevenueCat](https://img.shields.io/badge/Payments-RevenueCat-F25A5A)](https://revenuecat.com)
[![Groq](https://img.shields.io/badge/AI-Groq-F55036)](https://groq.com)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

---

## It's 11:47pm.

Something happened today. Maybe something good. Maybe something bad. Maybe nothing specific at all — you just feel heavy and you can't explain why.

You want to tell someone. You open your phone. You scroll your contacts. **There's no one to text.**

You open Instagram. Everyone looks happy. You feel worse. You close it. You stare at the ceiling.

**That's the moment Out Loud was built for.**

---

## What It Is

Out Loud is a mobile app for people who feel alone in a feeling.

You write one honest sentence — anything, no categories, no mood picker, no "select from this menu." A stranger who feels something similar writes back one sentence. That's it.

No names. No profiles. No followers. No likes. No feed to scroll. No history to haunt you.

Notes disappear in 24 hours. Nothing is searchable. Nothing follows you.

> **Not therapy. Not journaling. Not social media.**
> Just proof that you're not the only one feeling this right now.

---

## Why It Exists

Every wellness app asks you to pick from a menu of approved feelings: *happy, sad, anxious, grateful.*

**Real feelings don't fit menus.** The thing that hurts the most is usually the thing you can't name — or won't say out loud.

| What exists | Why it's not this |
|---|---|
| **Journaling apps** | Private. You're still alone with it. |
| **Social media** | Performative. Makes loneliness worse. |
| **Therapy apps** | Expensive, formal, appointment-based. Not for 11:47pm. |
| **AI chatbot friends** | You know it's a bot. It doesn't count. |
| **Wellness apps** | "Do this 5-minute breathing exercise." Not what you need. |

Out Loud doesn't try to *fix* the feeling. It doesn't try to *distract* you from it. It just shows you that someone else is inside it too.

**That's the whole product.**

---

## The Experience

### 🌸 It breathes with the seasons

The entire app — palette, illustrations, animations, taglines — shifts with the calendar. Spring shows petals drifting down. Summer glows with warm sun motes. Autumn scatters leaves. Winter snows, quietly.

| Season | Palette | Particles | Tagline |
|--------|---------|-----------|---------|
| 🌸 **Spring** | Soft pinks + mint | Falling petals | *New growth. New feelings.* |
| ☀️ **Summer** | Warm golds | Glowing sun motes | *Warmth in everything.* |
| 🍂 **Autumn** | Amber + rust | Drifting leaves | *Letting things fall away.* |
| ❄️ **Winter** | Cool blue-whites | Drifting snowflakes | *Rest. Reflect. Return.* |

The palette, particles, and taglines adapt automatically. Long-press the title to cycle through manually.

### 📝 You say it

Up to 500 characters. No titles. No tags. No "what kind of feeling is this?" dropdown. Just a text box that says: **"What do you need to say?"**

- *"I got into my dream school and nobody in my family cares."*
- *"I haven't talked to anyone in four days."*
- *"My dad is sick and I can't tell anyone at school."*
- *"I'm actually happy today for no reason."*
- *"I think I'm the problem."*

Whatever it is — it's allowed here.

### 💜 Someone feels it too

Tap the heart on any note to say *"I feel this too."* The count is public. **Your identity isn't.**

> *"4,291 people feel exactly this right now."*
>
> That number hits different than any feature ever could.

### 💬 One sentence back

Reply to a note with a single sentence. No threads. No reply chains. No way to keep escalating. Just one human sending one sentence to another human.

If you're stuck on what to say, tap **Suggest** — an AI writes a warm, empathetic reply based on what they shared. You can edit it before sending.

### 🧠 A place to talk

A dedicated support chat, powered by Groq. It's prompted to be warm, validating, and non-diagnostic. It doesn't try to fix you. It listens.

If you mention self-harm or suicide, **it immediately surfaces crisis helplines.** No hedging, no delay.

### 🆘 Safety is not optional

Crisis detection runs **before a note is displayed.** If the language signals self-harm, the crisis screen appears first — with local (Umang Pakistan) and international resources (Befrienders Worldwide, 988 US, Samaritans UK).

This isn't a bolt-on. It's the foundation.

### 💎 Out Loud+

An optional subscription. **The free tier stays free forever** — because selling access to connection would defeat the point.

Out Loud+ unlocks:
- Longer replies (more than one sentence)
- Resonance analytics (see who felt what, in aggregate)
- Private emotional patterns over time — *"you feel lonely most on Sunday nights, and it usually passes by morning"*

Powered by **RevenueCat**.

---

## Built With

| Layer | Choice | Why |
|-------|--------|-----|
| **Framework** | Flutter 3.24+ | One codebase, iOS + Android |
| **Auth** | Firebase Anonymous Auth | No signup friction, no PII |
| **Database** | Cloud Firestore | Real-time note feed |
| **Payments** | RevenueCat | Subscriptions done properly |
| **AI** | Groq API | Fast, free-tier, empathetic chat |
| **Chat UI** | `ai_chat_kit` | Drop-in conversational surface |
| **Typography** | Inter (Google Fonts) | Clean, warm, readable |
| **Key storage** | `shared_preferences` | BYOK, device-local only |

---

## Screenshots

> *1179 × 2556, no device frame.*

| Home | Post Note | AI Chat | Paywall |
|------|-----------|---------|---------|
| ![Home](screenshots/home.png) | ![Post](screenshots/post.png) | ![Chat](screenshots/chat.png) | ![Paywall](screenshots/paywall.png) |

---

## Getting Started

### Prerequisites

- **Flutter SDK** 3.24+
- **Android Studio** (for the Android SDK + emulator)
- A **Firebase** project (free Spark plan)
- A **RevenueCat** account (Test Store is free)
- A **Groq** account (free tier — 30 req/min)

### 1. Clone

```bash
git clone https://github.com/YOUR_USERNAME/out_loud.git
cd out_loud
flutter pub get
```

### 2. Set up Firebase

1. Create a project at [console.firebase.google.com](https://console.firebase.google.com)
2. Enable **Authentication → Anonymous**
3. Enable **Firestore Database** (test mode)
4. Run:

```bash
flutterfire configure
```

Select **Android**. This generates `lib/firebase_options.dart`.

### 3. Deploy Firestore rules

Paste this into **Firestore → Rules**, then **Publish**:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /notes/{noteId} {
      allow read: if true;
      allow create: if request.resource.data.text is string
                    && request.resource.data.text.size() > 0
                    && request.resource.data.text.size() < 500;
      allow update: if request.resource.data.diff(resource.data)
                    .affectedKeys()
                    .hasOnly(['resonanceCount', 'reply']);
      allow delete: if false;
    }
  }
}
```

### 4. Set up RevenueCat

1. Create a project at [app.revenuecat.com](https://app.revenuecat.com)
2. Add a **Test Store** app
3. Create product `pro_monthly` — subscription, $3.99/month
4. Create entitlement `pro` — attach the product
5. Create offering `default` — add the package, mark **Current**
6. Copy the **Test Store API key** (`test_...`)

### 5. Run

```bash
flutter run --dart-define=REVENUECAT_KEY=test_YOUR_KEY
```

### 6. Enter your Groq key in-app

1. Tap the **gear icon** in the top-right of the home screen
2. Paste your key from [console.groq.com/keys](https://console.groq.com/keys)
3. Tap **Save key** → hot restart (`R`)

**The key is stored locally on your device only. It never touches the source code.**

---

## Build the APK

For the hackathon demo:

```bash
flutter build apk --debug --dart-define=REVENUECAT_KEY=test_YOUR_KEY
```

Output:

```
build/app/outputs/flutter-apk/app-debug.apk
```

> **Why debug and not release?** RevenueCat's SDK crashes release builds that use a Test Store key — on purpose, to prevent shipping broken payments. Debug builds are safe.

---

## Security: Bring Your Own Key

**No API keys live in the source code.** This is deliberate.

| Key | How it enters the app | Where it lives |
|-----|----------------------|----------------|
| **RevenueCat** | Passed at build time via `--dart-define` | Never written to disk |
| **Groq** | User pastes in Settings screen | Saved to device `SharedPreferences` |

Anyone who clones this repo runs it with their own keys. **No shared secret is ever leaked.**

### Verify the repo is clean

```bash
git grep -n "gsk_"
git grep -n "test_[A-Za-z0-9]"
git grep -n "appl_"
```

All three should return **nothing**.

---

## Project Structure

```
lib/
├── main.dart                          # Entry point, SDK init
├── theme.dart                         # Design system
├── firebase_options.dart              # Generated by flutterfire
│
├── models/
│   └── note.dart                      # Note data model
│
├── screens/
│   ├── home_screen.dart               # Main feed + seasonal background
│   ├── post_note_screen.dart          # Write a note
│   ├── crisis_screen.dart             # Safety resources
│   ├── paywall_screen.dart            # Out Loud+ subscription
│   └── settings_screen.dart           # Groq API key entry
│
├── seasonal/
│   ├── season.dart                    # Season detection + palettes
│   └── seasonal_overlay.dart          # Animated particle system
│
└── services/
    ├── note_service.dart              # Firestore operations
    ├── crisis_detector.dart           # Crisis language detection
    ├── api_key_service.dart           # Device-local key storage
    └── groq_service.dart              # Groq API calls
```

---

## Safety & Ethics

Out Loud is designed for vulnerable people. Every choice reflects that.

- **Crisis detection runs before display.** Any note containing crisis language triggers the safety screen first.
- **No profiles, no PII.** There is nothing to collect, nothing to leak.
- **24-hour expiry.** Nothing is permanent. Nothing is searchable. Nothing is indexed.
- **The AI is bounded.** Prompted to acknowledge, never to diagnose. No medical advice.
- **The free tier stays free.** We're not selling access to connection.
- **Anonymous by default.** No email, no phone, no name. Ever.

---

## Roadmap

- [x] Anonymous notes with 24-hour expiry
- [x] One-sentence replies
- [x] Resonance counter
- [x] Seasonal UI (spring / summer / autumn / winter)
- [x] AI reply suggestions (Groq)
- [x] Support chat with crisis detection
- [x] RevenueCat subscription paywall
- [x] BYOK security model
- [ ] Emotion resonance map (anonymous, global, live)
- [ ] Voice notes
- [ ] iOS release

---

## Acknowledgements

- **RevenueCat** — for the Shipaton, and for making monetization accessible to indie devs
- **Groq** — for fast, free LLM inference
- **Firebase** — for auth and Firestore that just work
- **Flutter** — for making iOS + Android from one codebase feel effortless
- **The 4,291 people** who feel exactly what you're feeling right now

---

## License

MIT. See [LICENSE](LICENSE).

---

<div align="center">

**You're not alone in this.**

*Built for the RevenueCat Shipaton 2026 — Next Gen Award.*

</div>

---

