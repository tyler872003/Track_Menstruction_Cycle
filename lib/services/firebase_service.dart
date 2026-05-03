import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/cycle_data.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;
  String? get uid => _auth.currentUser?.uid;

  // ─── Auth ─────────────────────────────────────────────

  Future<UserCredential?> signIn(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
          email: email.trim(), password: password);
    } on FirebaseAuthException {
      rethrow;
    }
  }

  Future<UserCredential?> register(String email, String password, String name) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
          email: email.trim(), password: password);

      final user = credential.user;
      if (user == null) {
        throw Exception('Registration failed: user is null after account creation.');
      }

      await user.updateDisplayName(name);

      // Create default profile in Firestore
      await _firestore.collection('users').doc(user.uid).set({
        'name': name,
        'email': email.trim(),
        'cycleLength': 28,
        'periodLength': 5,
        'lastPeriodStart': Timestamp.fromDate(
            DateTime.now().subtract(const Duration(days: 14))),
      });

      return credential;
    } on FirebaseAuthException {
      rethrow;
    }
  }

  Future<void> signOut() => _auth.signOut();

  // ─── Profile ──────────────────────────────────────────

  Future<CycleProfile?> getProfile() async {
    if (uid == null) return null;
    final doc = await _firestore.collection('users').doc(uid).get();
    if (!doc.exists) return null;
    return CycleProfile.fromMap(uid!, doc.data()!);
  }

  Future<void> updateProfile(CycleProfile profile) async {
    if (uid == null) return;
    await _firestore.collection('users').doc(uid).update(profile.toMap());
  }

  // ─── Daily Logs ───────────────────────────────────────

  Future<void> saveDailyLog(DailyLog log) async {
    if (uid == null) return;
    final dateKey = _dateKey(log.date);
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('logs')
        .doc(dateKey)
        .set(log.toMap());
  }

  Future<DailyLog?> getLogForDate(DateTime date) async {
    if (uid == null) return null;
    final dateKey = _dateKey(date);
    final doc = await _firestore
        .collection('users')
        .doc(uid)
        .collection('logs')
        .doc(dateKey)
        .get();
    if (!doc.exists) return null;
    return DailyLog.fromMap(doc.id, doc.data()!);
  }

  Stream<List<DailyLog>> getLogsForMonth(int year, int month) {
    if (uid == null) return const Stream.empty();
    final start = DateTime(year, month, 1);
    final end = DateTime(year, month + 1, 0, 23, 59, 59);
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('logs')
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where('date', isLessThanOrEqualTo: Timestamp.fromDate(end))
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => DailyLog.fromMap(d.id, d.data()))
            .toList());
  }

  String _dateKey(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}
