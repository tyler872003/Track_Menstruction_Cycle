import 'package:cloud_firestore/cloud_firestore.dart';

enum FlowIntensity { none, light, medium, heavy, spotting }

enum EnergyLevel { low, medium, high }

enum MoodType { happy, sensitive, tired, anxious, calm, excited }

class DailyLog {
  final String id;
  final DateTime date;
  final MoodType? mood;
  final List<String> symptoms;
  final EnergyLevel energy;
  final FlowIntensity flow;
  final String? notes;

  DailyLog({
    required this.id,
    required this.date,
    this.mood,
    this.symptoms = const [],
    this.energy = EnergyLevel.medium,
    this.flow = FlowIntensity.none,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'date': Timestamp.fromDate(date),
      'mood': mood?.index,
      'symptoms': symptoms,
      'energy': energy.index,
      'flow': flow.index,
      'notes': notes,
    };
  }

  factory DailyLog.fromMap(String id, Map<String, dynamic> map) {
    return DailyLog(
      id: id,
      date: (map['date'] as Timestamp).toDate(),
      mood: map['mood'] != null ? MoodType.values[map['mood']] : null,
      symptoms: List<String>.from(map['symptoms'] ?? []),
      energy: EnergyLevel.values[map['energy'] ?? 1],
      flow: FlowIntensity.values[map['flow'] ?? 0],
      notes: map['notes'],
    );
  }
}

class CycleProfile {
  final String userId;
  final int cycleLength;
  final int periodLength;
  final DateTime lastPeriodStart;
  final String name;
  final String email;

  CycleProfile({
    required this.userId,
    required this.cycleLength,
    required this.periodLength,
    required this.lastPeriodStart,
    required this.name,
    required this.email,
  });

  DateTime get nextPeriodStart => lastPeriodStart.add(Duration(days: cycleLength));
  DateTime get ovulationDate => lastPeriodStart.add(Duration(days: cycleLength - 14));

  bool isPeriodDay(DateTime day) {
    final diff = day.difference(lastPeriodStart).inDays;
    return diff >= 0 && diff < periodLength;
  }

  bool isFertileWindow(DateTime day) {
    final ovulation = ovulationDate;
    final diff = day.difference(ovulation).inDays;
    return diff >= -2 && diff <= 2;
  }

  bool isOvulationDay(DateTime day) {
    final ovulation = ovulationDate;
    return day.year == ovulation.year &&
        day.month == ovulation.month &&
        day.day == ovulation.day;
  }

  String get currentPhase {
    final today = DateTime.now();
    final dayOfCycle = today.difference(lastPeriodStart).inDays % cycleLength;
    if (dayOfCycle < periodLength) return 'Menstrual';
    if (dayOfCycle < 13) return 'Follicular';
    if (dayOfCycle < 16) return 'Ovulation';
    return 'Luteal';
  }

  Map<String, dynamic> toMap() {
    return {
      'cycleLength': cycleLength,
      'periodLength': periodLength,
      'lastPeriodStart': Timestamp.fromDate(lastPeriodStart),
      'name': name,
      'email': email,
    };
  }

  factory CycleProfile.fromMap(String userId, Map<String, dynamic> map) {
    return CycleProfile(
      userId: userId,
      cycleLength: map['cycleLength'] ?? 28,
      periodLength: map['periodLength'] ?? 5,
      lastPeriodStart: map['lastPeriodStart'] != null
          ? (map['lastPeriodStart'] as Timestamp).toDate()
          : DateTime.now().subtract(const Duration(days: 14)),
      name: map['name'] ?? 'User',
      email: map['email'] ?? '',
    );
  }
}
