import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../providers/app_provider.dart';
import '../models/cycle_data.dart';
import '../widgets/shared_widgets.dart';

class DailyCheckInScreen extends StatefulWidget {
  const DailyCheckInScreen({super.key});

  @override
  State<DailyCheckInScreen> createState() => _DailyCheckInScreenState();
}

class _DailyCheckInScreenState extends State<DailyCheckInScreen> {
  MoodType? _selectedMood;
  final Set<String> _selectedSymptoms = {};
  EnergyLevel _energyLevel = EnergyLevel.medium;
  FlowIntensity _flowIntensity = FlowIntensity.none;
  bool _saving = false;

  static const _moods = [
    (MoodType.happy, Icons.sentiment_very_satisfied_rounded, 'Happy'),
    (MoodType.sensitive, Icons.favorite_rounded, 'Sensitive'),
    (MoodType.tired, Icons.bedtime_rounded, 'Tired'),
    (MoodType.anxious, Icons.waves_rounded, 'Anxious'),
  ];

  static const _symptoms = [
    ('Cramps', Icons.bolt_rounded),
    ('Bloating', Icons.cloud_rounded),
    ('Headache', Icons.psychology_rounded),
    ('Acne', Icons.spa_rounded),
    ('Backache', Icons.accessibility_rounded),
    ('Mood swings', Icons.mood_rounded),
    ('Fatigue', Icons.battery_0_bar_rounded),
    ('Nausea', Icons.sick_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.85),
        elevation: 0,
        leadingWidth: 56,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: IconButton(
            icon: const Icon(Icons.close_rounded, color: AppColors.onSurface),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: Row(
          children: [
            const Icon(Icons.calendar_today_rounded,
                color: AppColors.primaryContainer, size: 18),
            const SizedBox(width: 8),
            Text(
              DateFormat('EEEE, MMM d').format(DateTime.now()),
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurface),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mood Section
            const SectionHeader(
              title: 'How are you feeling?',
              subtitle: 'Check in with your emotional state',
            ),
            const SizedBox(height: 14),
            GridView.count(
              crossAxisCount: 4,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: _moods.map((m) {
                final isSelected = _selectedMood == m.$1;
                return GestureDetector(
                  onTap: () => setState(() => _selectedMood = m.$1),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primaryFixed.withOpacity(0.5)
                          : AppColors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(m.$2,
                            size: 30,
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.primaryContainer),
                        const SizedBox(height: 4),
                        Text(m.$3,
                            style: TextStyle(
                                fontSize: 11,
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.onSurfaceVariant)),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 28),

            // Symptoms Section
            const SectionHeader(title: 'Symptoms'),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _symptoms.map((s) {
                final isSelected = _selectedSymptoms.contains(s.$1);
                return CategoryChip(
                  label: s.$1,
                  icon: s.$2,
                  selected: isSelected,
                  onTap: () => setState(() {
                    if (isSelected) {
                      _selectedSymptoms.remove(s.$1);
                    } else {
                      _selectedSymptoms.add(s.$1);
                    }
                  }),
                );
              }).toList(),
            ),
            const SizedBox(height: 28),

            // Energy Level
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.secondaryContainer.withOpacity(0.25),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Energy Level',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppColors.secondary)),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.secondaryFixed,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Text(
                          _energyLabel(_energyLevel),
                          style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.secondary,
                              letterSpacing: 0.5),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SliderTheme(
                    data: SliderThemeData(
                      trackHeight: 8,
                      activeTrackColor: AppColors.secondary,
                      inactiveTrackColor: AppColors.secondaryFixed,
                      thumbColor: AppColors.secondary,
                      overlayColor: AppColors.secondary.withOpacity(0.2),
                      thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 10),
                    ),
                    child: Slider(
                      value: _energyLevel.index.toDouble(),
                      min: 0,
                      max: 2,
                      divisions: 2,
                      onChanged: (v) => setState(
                          () => _energyLevel = EnergyLevel.values[v.round()]),
                    ),
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Low',
                          style: TextStyle(
                              fontSize: 12, color: AppColors.secondary)),
                      Text('Medium',
                          style: TextStyle(
                              fontSize: 12, color: AppColors.secondary)),
                      Text('High',
                          style: TextStyle(
                              fontSize: 12, color: AppColors.secondary)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Flow Intensity
            const SectionHeader(title: 'Flow'),
            const SizedBox(height: 12),
            Row(
              children: FlowIntensity.values.map((f) {
                final isSelected = _flowIntensity == f;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _flowIntensity = f),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      height: 64,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primaryFixed
                            : AppColors.surfaceContainer,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _flowIcon(f, isSelected),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: FlowIntensity.values
                  .map((f) => Text(_flowLabel(f),
                      style: const TextStyle(
                          fontSize: 10,
                          color: AppColors.onSurfaceVariant,
                          fontWeight: FontWeight.w600)))
                  .toList(),
            ),
            const SizedBox(height: 28),

            // Daily tip card
            Container(
              height: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withOpacity(0.85),
                    AppColors.primaryContainer.withOpacity(0.9),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: -20,
                    top: -20,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primaryContainer,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: const Text('Daily Tip',
                              style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.onPrimaryContainer,
                                  letterSpacing: 0.5)),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Magnesium might help with those cramps today.',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              height: 1.3),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 36),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              AppColors.background,
              AppColors.background.withOpacity(0.0),
            ],
          ),
        ),
        child: ElevatedButton.icon(
          onPressed: _saving ? null : _saveLog,
          icon: _saving
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white))
              : const Icon(Icons.check_circle_rounded, size: 20),
          label: Text(_saving ? 'Saving...' : 'Save Log'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryContainer,
            foregroundColor: AppColors.primary,
            minimumSize: const Size.fromHeight(58),
            shape: const StadiumBorder(),
            textStyle: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.w700),
            shadowColor: AppColors.primaryContainer.withOpacity(0.6),
            elevation: 8,
          ),
        ),
      ),
    );
  }

  Future<void> _saveLog() async {
    setState(() => _saving = true);
    final log = DailyLog(
      id: '',
      date: DateTime.now(),
      mood: _selectedMood,
      symptoms: _selectedSymptoms.toList(),
      energy: _energyLevel,
      flow: _flowIntensity,
    );
    await context.read<AppProvider>().saveDailyLog(log);
    if (mounted) {
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Check-in saved! 🌸'),
          backgroundColor: AppColors.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      Navigator.pop(context);
    }
  }

  String _energyLabel(EnergyLevel e) {
    switch (e) {
      case EnergyLevel.low: return 'LOW';
      case EnergyLevel.medium: return 'MEDIUM';
      case EnergyLevel.high: return 'HIGH';
    }
  }

  String _flowLabel(FlowIntensity f) {
    switch (f) {
      case FlowIntensity.none: return 'None';
      case FlowIntensity.light: return 'Light';
      case FlowIntensity.medium: return 'Medium';
      case FlowIntensity.heavy: return 'Heavy';
      case FlowIntensity.spotting: return 'Spot';
    }
  }

  Widget _flowIcon(FlowIntensity f, bool selected) {
    final color =
        selected ? AppColors.primary : AppColors.primaryContainer;
    switch (f) {
      case FlowIntensity.none:
        return Text('None',
            style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: selected ? AppColors.primary : AppColors.onSurfaceVariant));
      case FlowIntensity.light:
        return Icon(Icons.water_drop_outlined, color: color, size: 24);
      case FlowIntensity.medium:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.water_drop_rounded, color: color, size: 20),
            Icon(Icons.water_drop_rounded, color: color, size: 20),
          ],
        );
      case FlowIntensity.heavy:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.water_drop_rounded, color: color, size: 18),
            Icon(Icons.water_drop_rounded, color: color, size: 18),
            Icon(Icons.water_drop_rounded, color: color, size: 18),
          ],
        );
      case FlowIntensity.spotting:
        return Icon(Icons.opacity_rounded, color: color, size: 26);
    }
  }
}
