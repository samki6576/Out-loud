
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/note.dart';

class NoteService {
  final _col = FirebaseFirestore.instance.collection('notes');

  Future<void> postNote(String text) async {
    final now = DateTime.now();
    final note = Note(
      id: '',
      text: text,
      createdAt: now,
      expiresAt: now.add(const Duration(hours: 24)),
    );
    await _col.add(note.toMap());
  }

  Stream<List<Note>> streamRecentNotes() {
    return _col
        .orderBy('createdAt', descending: true)
        .limit(60)
        .snapshots()
        .map((s) => s.docs
            .map((d) => Note.fromDoc(d))
            .where((n) => n.expiresAt.isAfter(DateTime.now()))
            .toList());
  }

  Future<void> resonate(String noteId) async {
    await _col.doc(noteId).update({
      'resonanceCount': FieldValue.increment(1),
    });
  }

  Future<void> reply(String noteId, String replyText) async {
    await _col.doc(noteId).update({'reply': replyText});
  }
}