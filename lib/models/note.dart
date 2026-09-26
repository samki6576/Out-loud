import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  final String id;
  final String text;
  final DateTime createdAt;
  final DateTime expiresAt;
  final int resonanceCount;
  final String? reply;

  Note({
    required this.id,
    required this.text,
    required this.createdAt,
    required this.expiresAt,
    this.resonanceCount = 0,
    this.reply,
  });

  factory Note.fromDoc(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return Note(
      id: doc.id,
      text: d['text'] ?? '',
      createdAt: (d['createdAt'] as Timestamp).toDate(),
      expiresAt: (d['expiresAt'] as Timestamp).toDate(),
      resonanceCount: d['resonanceCount'] ?? 0,
      reply: d['reply'],
    );
  }

  Map<String, dynamic> toMap() => {
        'text': text,
        'createdAt': Timestamp.fromDate(createdAt),
        'expiresAt': Timestamp.fromDate(expiresAt),
        'resonanceCount': resonanceCount,
        'reply': reply,
      };
}