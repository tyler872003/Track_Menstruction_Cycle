import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/app_provider.dart';
import '../models/cycle_data.dart';
import '../widgets/shared_widgets.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _healthSync = true;
  bool _notifications = true;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final profile = provider.profile;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const BloomAppBar(showLogo: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile card
            GlassCard(
              child: Row(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [
                          AppColors.primaryContainer,
                          AppColors.primaryFixed
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      border: Border.all(color: Colors.white, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryContainer.withOpacity(0.5),
                          blurRadius: 15,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.person_rounded,
                        size: 32, color: AppColors.primary),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          profile?.name ?? 'Your Name',
                          style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: AppColors.onSurface),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          profile?.email ?? 'email@example.com',
                          style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Premium status card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primaryFixed, AppColors.primaryContainer],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryContainer.withOpacity(0.35),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.4),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.stars_rounded,
                        color: AppColors.primary, size: 24),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('STATUS',
                            style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: AppColors.onPrimaryContainer,
                                letterSpacing: 1)),
                        Text('Premium Member',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary)),
                      ],
                    ),
                  ),
                  const Icon(Icons.verified_rounded,
                      color: AppColors.primary, size: 28),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Cycle settings
            const Text('Cycle Settings',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurface)),
            const SizedBox(height: 12),

            if (profile != null) ...[
              _CycleLengthEditor(profile: profile),
              const SizedBox(height: 12),
            ],

            // Settings section
            const SizedBox(height: 16),
            const Text('App Settings',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurface)),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryContainer.withOpacity(0.12),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _SettingsItem(
                    icon: Icons.person_rounded,
                    iconBg: AppColors.secondaryFixed,
                    iconColor: AppColors.secondary,
                    title: 'Account',
                    subtitle: 'Manage your personal details',
                    onTap: () {},
                  ),
                  _Divider(),
                  _SettingsItem(
                    icon: Icons.notifications_rounded,
                    iconBg: AppColors.tertiaryFixed,
                    iconColor: AppColors.tertiary,
                    title: 'Notifications',
                    subtitle: 'Customize your reminders',
                    trailing: Switch(
                      value: _notifications,
                      onChanged: (v) => setState(() => _notifications = v),
                      activeColor: AppColors.primary,
                    ),
                  ),
                  _Divider(),
                  _SettingsItem(
                    icon: Icons.lock_rounded,
                    iconBg: AppColors.surfaceVariant,
                    iconColor: AppColors.onSurfaceVariant,
                    title: 'App Lock',
                    subtitle: 'Secure your data with biometrics',
                    onTap: () {},
                  ),
                  _Divider(),
                  _SettingsItem(
                    icon: Icons.favorite_rounded,
                    iconBg: AppColors.primaryFixed,
                    iconColor: AppColors.primary,
                    title: 'Sync with Health',
                    subtitle: 'Keep your data connected',
                    trailing: Switch(
                      value: _healthSync,
                      onChanged: (v) => setState(() => _healthSync = v),
                      activeColor: AppColors.primary,
                    ),
                  ),
                  _Divider(),
                  _SettingsItem(
                    icon: Icons.help_rounded,
                    iconBg: AppColors.secondaryContainer,
                    iconColor: AppColors.onSecondaryContainer,
                    title: 'Help & Support',
                    subtitle: 'FAQs and contact us',
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Log out
            Center(
              child: TextButton(
                onPressed: () async {
                  await context.read<AppProvider>().signOut();
                  if (context.mounted) {
                    Navigator.pushReplacementNamed(context, '/auth');
                  }
                },
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.error,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 12),
                  shape: const StadiumBorder(),
                ),
                child: const Text('Log Out',
                    style: TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(
        height: 0.5,
        color: AppColors.outlineVariant.withOpacity(0.5),
        indent: 70);
  }
}

class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;

  const _SettingsItem({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      onTap: onTap,
      leading: Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          color: iconBg,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: iconColor, size: 22),
      ),
      title: Text(title,
          style: const TextStyle(
              fontSize: 15, fontWeight: FontWeight.w600,
              color: AppColors.onSurface)),
      subtitle: Text(subtitle,
          style: const TextStyle(
              fontSize: 12, color: AppColors.onSurfaceVariant)),
      trailing: trailing ??
          const Icon(Icons.chevron_right_rounded,
              color: AppColors.outlineVariant),
    );
  }
}

class _CycleLengthEditor extends StatefulWidget {
  final CycleProfile profile;
  const _CycleLengthEditor({required this.profile});

  @override
  State<_CycleLengthEditor> createState() => _CycleLengthEditorState();
}

class _CycleLengthEditorState extends State<_CycleLengthEditor> {
  late int _cycleLength;
  late int _periodLength;

  @override
  void initState() {
    super.initState();
    _cycleLength = widget.profile.cycleLength;
    _periodLength = widget.profile.periodLength;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.primaryFixed.withOpacity(0.25),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primaryFixed.withOpacity(0.4)),
      ),
      child: Column(
        children: [
          _CycleStepper(
            label: 'Cycle Length',
            value: _cycleLength,
            unit: 'days',
            min: 21,
            max: 45,
            onChanged: (v) {
              setState(() => _cycleLength = v);
              _save();
            },
          ),
          const Divider(height: 20, color: AppColors.outlineVariant),
          _CycleStepper(
            label: 'Period Length',
            value: _periodLength,
            unit: 'days',
            min: 2,
            max: 10,
            onChanged: (v) {
              setState(() => _periodLength = v);
              _save();
            },
          ),
        ],
      ),
    );
  }

  void _save() {
    final updated = CycleProfile(
      userId: widget.profile.userId,
      name: widget.profile.name,
      email: widget.profile.email,
      cycleLength: _cycleLength,
      periodLength: _periodLength,
      lastPeriodStart: widget.profile.lastPeriodStart,
    );
    context.read<AppProvider>().updateProfile(updated);
  }
}

class _CycleStepper extends StatelessWidget {
  final String label;
  final int value;
  final String unit;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  const _CycleStepper({
    required this.label,
    required this.value,
    required this.unit,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.onSurface)),
        Row(
          children: [
            _StepBtn(
              icon: Icons.remove_rounded,
              onTap: value > min ? () => onChanged(value - 1) : null,
            ),
            const SizedBox(width: 12),
            Text('$value $unit',
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary)),
            const SizedBox(width: 12),
            _StepBtn(
              icon: Icons.add_rounded,
              onTap: value < max ? () => onChanged(value + 1) : null,
            ),
          ],
        ),
      ],
    );
  }
}

class _StepBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  const _StepBtn({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: onTap != null ? AppColors.primary : AppColors.outlineVariant,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 16),
      ),
    );
  }
}
