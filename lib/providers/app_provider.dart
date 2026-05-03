import 'package:flutter/material.dart';
import '../models/cycle_data.dart';
import '../services/firebase_service.dart';

class AppProvider extends ChangeNotifier {
  final FirebaseService _service = FirebaseService();

  CycleProfile? _profile;
  List<DailyLog> _monthLogs = [];
  bool _loading = false;
  String? _error;

  CycleProfile? get profile => _profile;
  List<DailyLog> get monthLogs => _monthLogs;
  bool get loading => _loading;
  String? get error => _error;
  bool get isLoggedIn => _service.currentUser != null;

  Future<void> loadProfile() async {
    _loading = true;
    notifyListeners();
    try {
      _profile = await _service.getProfile();
      _error = null;
    } catch (e) {
      _error = e.toString();
    }
    _loading = false;
    notifyListeners();
  }

  Future<bool> signIn(String email, String password) async {
    _loading = true;
    notifyListeners();
    try {
      await _service.signIn(email, password);
      await loadProfile();
      _loading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = _friendlyAuthError(e.toString());
      _loading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String email, String password, String name) async {
    _loading = true;
    notifyListeners();
    try {
      await _service.register(email, password, name);
      await loadProfile();
      _loading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = _friendlyAuthError(e.toString());
      _loading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async {
    await _service.signOut();
    _profile = null;
    _monthLogs = [];
    notifyListeners();
  }

  void loadLogsForMonth(int year, int month) {
    _service.getLogsForMonth(year, month).listen((logs) {
      _monthLogs = logs;
      notifyListeners();
    });
  }

  Future<void> saveDailyLog(DailyLog log) async {
    await _service.saveDailyLog(log);
  }

  Future<DailyLog?> getLogForDate(DateTime date) =>
      _service.getLogForDate(date);

  Future<void> updateProfile(CycleProfile profile) async {
    await _service.updateProfile(profile);
    _profile = profile;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  String _friendlyAuthError(String error) {
    if (error.contains('user-not-found')) return 'No account found with this email.';
    if (error.contains('wrong-password')) return 'Incorrect password.';
    if (error.contains('email-already-in-use')) return 'This email is already registered.';
    if (error.contains('weak-password')) return 'Password must be at least 6 characters.';
    if (error.contains('invalid-email')) return 'Invalid email address.';
    if (error.contains('network-request-failed')) return 'No internet connection.';
    return 'Something went wrong. Please try again.';
  }
}
