import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../providers/app_provider.dart';
import '../models/cycle_data.dart';
import '../widgets/shared_widgets.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppProvider>().loadLogsForMonth(
          _focusedDay.year, _focusedDay.month);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final profile = provider.profile;
    final logs = provider.monthLogs;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const BloomAppBar(showLogo: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Month header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat('MMMM yyyy').format(_focusedDay),
                      style: const TextStyle(
                          fontSize: 26, fontWeight: FontWeight.w700,
                          color: AppColors.primary),
                    ),
                    if (profile != null)
                      Text(
                        'Phase: ${profile.currentPhase}',
                        style: const TextStyle(
                            fontSize: 13, color: AppColors.onSurfaceVariant),
                      ),
                  ],
                ),
                Row(
                  children: [
                    _NavBtn(
                      icon: Icons.chevron_left_rounded,
                      onTap: () => setState(() {
                        _focusedDay = DateTime(
                            _focusedDay.year, _focusedDay.month - 1);
                        context.read<AppProvider>().loadLogsForMonth(
                            _focusedDay.year, _focusedDay.month);
                      }),
                    ),
                    const SizedBox(width: 8),
                    _NavBtn(
                      icon: Icons.chevron_right_rounded,
                      onTap: () => setState(() {
                        _focusedDay = DateTime(
                            _focusedDay.year, _focusedDay.month + 1);
                        context.read<AppProvider>().loadLogsForMonth(
                            _focusedDay.year, _focusedDay.month);
                      }),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Calendar card
            GlassCard(
              padding: const EdgeInsets.all(12),
              child: TableCalendar(
                firstDay: DateTime.utc(2023, 1, 1),
                lastDay: DateTime.utc(2027, 12, 31),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                calendarFormat: CalendarFormat.month,
                headerVisible: false,
                daysOfWeekStyle: const DaysOfWeekStyle(
                  weekdayStyle: TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w600,
                      color: AppColors.outline),
                  weekendStyle: TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w600,
                      color: AppColors.primaryContainer),
                ),
                calendarStyle: CalendarStyle(
                  outsideDaysVisible: true,
                  outsideTextStyle: const TextStyle(
                      fontSize: 13, color: AppColors.outlineVariant),
                  defaultTextStyle: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w500,
                      color: AppColors.onSurface),
                  weekendTextStyle: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w500,
                      color: AppColors.onSurface),
                  todayDecoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  todayTextStyle: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w700,
                      color: Colors.white),
                  selectedDecoration: const BoxDecoration(
                    color: AppColors.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  selectedTextStyle: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w700,
                      color: AppColors.primary),
                  markerDecoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  markerSize: 5,
                  markersMaxCount: 1,
                ),
                calendarBuilders: CalendarBuilders(
                  defaultBuilder: (ctx, day, focusedDay) {
                    return _buildDayCell(day, profile, logs);
                  },
                  todayBuilder: (ctx, day, focusedDay) {
                    return _buildDayCell(day, profile, logs, isToday: true);
                  },
                ),
                onDaySelected: (selected, focused) {
                  setState(() {
                    _selectedDay = selected;
                    _focusedDay = focused;
                  });
                },
                onPageChanged: (focused) {
                  setState(() => _focusedDay = focused);
                  context.read<AppProvider>().loadLogsForMonth(
                      focused.year, focused.month);
                },
              ),
            ),
            const SizedBox(height: 20),

            // Legend
            _buildLegend(),
            const SizedBox(height: 24),

            // Monthly overview bento
            _buildMonthlyOverview(profile),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/checkin'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: const Icon(Icons.add_rounded, size: 28),
      ),
    );
  }

  Widget _buildDayCell(DateTime day, CycleProfile? profile, List<DailyLog> logs,
      {bool isToday = false}) {
    bool isPeriod = profile?.isPeriodDay(day) ?? false;
    bool isFertile = profile?.isFertileWindow(day) ?? false;
    bool isOvulation = profile?.isOvulationDay(day) ?? false;
    bool hasLog = logs.any((l) =>
        l.date.year == day.year &&
        l.date.month == day.month &&
        l.date.day == day.day);

    Color? bgColor;
    Color textColor = AppColors.onSurface;
    Border? border;

    if (isToday) {
      bgColor = AppColors.primary;
      textColor = Colors.white;
    } else if (isOvulation) {
      border = Border.all(color: AppColors.secondary, width: 1.5);
      textColor = AppColors.secondary;
    } else if (isPeriod) {
      bgColor = AppColors.primaryContainer.withOpacity(0.5);
      textColor = AppColors.primary;
    }

    return Container(
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
        border: border,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            '${day.day}',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
          if (isFertile && !isOvulation)
            Positioned(
              bottom: 3,
              child: Container(
                width: 20,
                height: 2,
                decoration: BoxDecoration(
                  color: AppColors.secondary.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          if (hasLog)
            Positioned(
              bottom: 2,
              child: Container(
                width: 4,
                height: 4,
                decoration: const BoxDecoration(
                  color: AppColors.tertiaryContainer,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLegend() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Guide',
            style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.outline,
                letterSpacing: 1.2)),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 10,
          childAspectRatio: 4,
          children: [
            _LegendItem(
                color: AppColors.primaryContainer.withOpacity(0.6),
                label: 'Period Days'),
            _LegendItem(
                isCircle: true,
                borderColor: AppColors.secondary,
                label: 'Ovulation'),
            _LegendItem(
                color: AppColors.tertiaryContainer,
                isSmall: true,
                label: 'Logged Symptoms'),
            _LegendItem(
                isBar: true,
                barColor: AppColors.secondaryContainer,
                label: 'Fertility Window'),
          ],
        ),
      ],
    );
  }

  Widget _buildMonthlyOverview(CycleProfile? profile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Monthly Overview',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.w700,
                color: AppColors.onSurface)),
        const SizedBox(height: 14),
        // Upcoming phase full-width
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.primaryContainer.withOpacity(0.2),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
                color: AppColors.primaryContainer.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Upcoming Phase',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                            letterSpacing: 0.5)),
                    const SizedBox(height: 4),
                    Text(
                      profile?.currentPhase ?? 'Luteal Phase',
                      style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      profile != null
                          ? 'Next period in ${profile.nextPeriodStart.difference(DateTime.now()).inDays} days'
                          : 'Track your cycle to see predictions',
                      style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.onPrimaryContainer),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.event_note_rounded,
                  color: AppColors.primary, size: 28),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                label: 'Cycle Length',
                value: '${profile?.cycleLength ?? 28} Days',
                color: AppColors.secondaryContainer.withOpacity(0.4),
                textColor: AppColors.secondary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                label: 'Period Length',
                value: '${profile?.periodLength ?? 5} Days',
                color: AppColors.tertiaryFixed.withOpacity(0.6),
                textColor: AppColors.tertiary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _NavBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _NavBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, size: 20, color: AppColors.onSurface),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color? color;
  final String label;
  final bool isCircle;
  final Color? borderColor;
  final bool isSmall;
  final bool isBar;
  final Color? barColor;

  const _LegendItem({
    this.color,
    required this.label,
    this.isCircle = false,
    this.borderColor,
    this.isSmall = false,
    this.isBar = false,
    this.barColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          if (isBar)
            Container(width: 16, height: 3,
                decoration: BoxDecoration(
                    color: barColor, borderRadius: BorderRadius.circular(2)))
          else if (isSmall)
            Container(width: 8, height: 8,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle))
          else if (isCircle)
            Container(width: 14, height: 14,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: borderColor!, width: 2)))
          else
            Container(width: 14, height: 14,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(label,
                style: const TextStyle(
                    fontSize: 12, color: AppColors.onSurfaceVariant),
                overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final Color textColor;

  const _StatCard({
    required this.label,
    required this.value,
    required this.color,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: 12, fontWeight: FontWeight.w600,
                  color: textColor)),
          const SizedBox(height: 4),
          Text(value,
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w700,
                  color: textColor)),
        ],
      ),
    );
  }
}
