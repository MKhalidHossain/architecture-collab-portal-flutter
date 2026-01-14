import 'dart:ui';
import 'package:dana_bozzetto/moduls/setting/presentation/screen/change_password_screen.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _glassCard(
            child: Column(
              children: [
                _SwitchRow(
                  icon: Icons.message_outlined,
                  title: 'Massage Notification',
                  value: true,
                  onChanged: (v) {},
                ),
                const SizedBox(height: 16),
                _SwitchRow(
                  icon: Icons.check_circle_outline,
                  title: 'Approval Requests',
                  value: false,
                  onChanged: (v) {},
                ),
                const SizedBox(height: 16),
                _SwitchRow(
                  icon: Icons.update,
                  title: 'Project Updates',
                  value: true,
                  onChanged: (v) {},
                ),
                const SizedBox(height: 16),
                _SwitchRow(
                  icon: Icons.payments_outlined,
                  title: 'Invoices & Payments',
                  value: true,
                  onChanged: (v) {},
                ),
                const SizedBox(height: 16),
                _SwitchRow(
                  icon: Icons.bar_chart_outlined,
                  title: 'Milestone Completion',
                  value: true,
                  onChanged: (v) {},
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          _glassCard(
            child: Column(
              children: [
                _NavigationRow(
                  icon: Icons.language,
                  title: 'Language',
                  subtitle: 'English (US)',
                  onTap: () {},
                ),
                const SizedBox(height: 16),
                _NavigationRow(
                  icon: Icons.lock_outline,
                  title: 'Change Password',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChangePasswordScreen()),
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          Center(
            child: Text(
              'Version 1.0.0',
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _glassCard({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.35),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.25)),
          ),
          child: child,
        ),
      ),
    );
  }
}

class _SwitchRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchRow({
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.white70, size: 22),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: Colors.white,
          activeTrackColor: const Color(0xFF01676C),
          inactiveThumbColor: Color(0xFF212730),
          inactiveTrackColor: Color(0xFFA8ADB5),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ],
    );
  }
}
class _NavigationRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  const _NavigationRow({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: Colors.white70, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 13,
                    ),
                  ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.white54),
        ],
      ),
    );
  }
}
