import 'dart:ui';
import 'package:dana_bozzetto/core/notifiers/snackbar_notifier.dart';
import 'package:dana_bozzetto/moduls/setting/controller/settings_controller.dart';
import 'package:dana_bozzetto/moduls/setting/model/settings_models.dart';
import 'package:dana_bozzetto/moduls/setting/presentation/screen/change_password_screen.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final SettingsController _controller;

  @override
  void initState() {
    super.initState();
    _controller = SettingsController();
    _controller.fetchSettings();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final isLoading = _controller.isLoading && !_controller.hasLoaded;
        final hasError = _controller.errorMessage.isNotEmpty;
        final settings = _controller.settings;

        return Scaffold(
          backgroundColor: Colors.transparent,
          body: isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.white70),
                )
              : hasError && !_controller.hasLoaded
                  ? _ErrorCard(
                      message: _controller.errorMessage,
                      onRetry: _controller.fetchSettings,
                    )
                  : ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        _glassCard(
                          child: Column(
                            children: [
                              _SwitchRow(
                                icon: Icons.message_outlined,
                                title: 'Massage Notification',
                                value: settings.notifications.messages,
                                onChanged: (v) => _onToggle('messages', v),
                              ),
                              const SizedBox(height: 16),
                              _SwitchRow(
                                icon: Icons.check_circle_outline,
                                title: 'Approval Requests',
                                value: settings.notifications.approvals,
                                onChanged: (v) => _onToggle('approvals', v),
                              ),
                              const SizedBox(height: 16),
                              _SwitchRow(
                                icon: Icons.update,
                                title: 'Project Updates',
                                value: settings.notifications.projectUpdates,
                                onChanged: (v) =>
                                    _onToggle('projectUpdates', v),
                              ),
                              const SizedBox(height: 16),
                              _SwitchRow(
                                icon: Icons.payments_outlined,
                                title: 'Invoices & Payments',
                                value: settings.notifications.invoices,
                                onChanged: (v) => _onToggle('invoices', v),
                              ),
                              const SizedBox(height: 16),
                              _SwitchRow(
                                icon: Icons.bar_chart_outlined,
                                title: 'Milestone Completion',
                                value: settings.notifications.milestones,
                                onChanged: (v) => _onToggle('milestones', v),
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
                                subtitle: settings.language.isNotEmpty
                                    ? settings.language
                                    : 'Select',
                                onTap: () => _selectLanguage(settings),
                              ),
                              const SizedBox(height: 16),
                              _NavigationRow(
                                icon: Icons.lock_outline,
                                title: 'Change Password',
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const ChangePasswordScreen(),
                                    ),
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
      },
    );
  }

  void _onToggle(String key, bool value) {
    final notifier = SnackbarNotifier(context: context);
    _controller.updateNotification(key: key, value: value).then((ok) {
      if (!ok && mounted) {
        notifier.notifyError(message: _controller.errorMessage);
      } else if (ok && mounted) {
        final label = _notificationLabel(key);
        if (label.isNotEmpty) {
          notifier.notifySuccess(
            message: value ? '$label enabled' : '$label disabled',
          );
        }
      }
    });
  }

  String _notificationLabel(String key) {
    switch (key) {
      case 'messages':
        return 'Message notifications';
      case 'approvals':
        return 'Approval requests';
      case 'projectUpdates':
        return 'Project updates';
      case 'invoices':
        return 'Invoices & payments';
      case 'milestones':
        return 'Milestone completion';
      default:
        return '';
    }
  }

  Future<void> _selectLanguage(SettingsData settings) async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.black.withOpacity(0.85),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        final languages = ['English (US)', 'Spanish'];
        return ListView(
          shrinkWrap: true,
          children: [
            const SizedBox(height: 12),
            for (final lang in languages)
              ListTile(
                title: Text(
                  lang,
                  style: const TextStyle(color: Colors.white),
                ),
                trailing: settings.language == lang
                    ? const Icon(Icons.check, color: Colors.white70)
                    : null,
                onTap: () => Navigator.pop(context, lang),
              ),
            const SizedBox(height: 12),
          ],
        );
      },
    );

    if (selected == null || selected == settings.language) {
      return;
    }
    final notifier = SnackbarNotifier(context: context);
    final ok = await _controller.updateLanguage(selected);
    if (!ok) {
      notifier.notifyError(message: _controller.errorMessage);
    }
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
          inactiveThumbColor: const Color(0xFF212730),
          inactiveTrackColor: const Color(0xFFA8ADB5),
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

class _ErrorCard extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorCard({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: onRetry,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
