class CrisisDetector {
  static const _crisisTerms = [
    'kill myself', 'end it all', 'suicide', 'want to die',
    'hurt myself', 'self harm', 'no reason to live', 'better off dead',
    "can't go on", 'ending my life', 'cut myself', 'not worth living',
  ];

  static bool isCrisis(String text) {
    final lower = text.toLowerCase();
    return _crisisTerms.any((term) => lower.contains(term));
  }
}