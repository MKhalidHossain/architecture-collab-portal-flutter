import 'dart:ui';
import 'package:dana_bozzetto/core/notifiers/snackbar_notifier.dart';
import 'package:dana_bozzetto/core/services/app_pigeon/app_pigeon.dart';
import 'package:dana_bozzetto/moduls/auth/interface/auth_interface.dart';
import 'package:dana_bozzetto/moduls/auth/model/logout_request_model.dart';
import 'package:dana_bozzetto/moduls/auth/presentation/screen/login_screen.dart';
import 'package:dana_bozzetto/moduls/profile/presentation/screen/edit_profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileBody extends StatelessWidget {
  const ProfileBody({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _sectionTitle('Contact Information'),
        _glassCard(
          child: Column(
            children: const [
              _ContactRow(
                icon: Icons.email_outlined,
                text: 'Client@example.com',
              ),
              SizedBox(height: 16),
              _ContactRow(
                icon: Icons.phone_outlined,
                text: '+1 (555) 123-4567',
              ),
              SizedBox(height: 16),
              _ContactRow(
                icon: Icons.location_on_outlined,
                text: 'Los Angeles, CA',
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        _sectionTitle('Account'),
        _glassCard(
          child: Column(
            children: [
              _MenuRow(
                icon: Icons.person_outline,
                title: 'Edit Profile',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => EditProfileScreen()),
                  );
                },
              ),
              SizedBox(height: 16),

              _MenuRow(
                icon: Icons.notifications_none,
                title: 'Notifications',
                badge: '02',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => Scaffold()),
                  );
                },
              ),
              SizedBox(height: 16),

              _MenuRow(
                icon: Icons.lock_outline,
                title: 'Privacy & Security',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => Scaffold()),
                  );
                },
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        _sectionTitle('Support'),
        _glassCard(
          child: Column(
            children: [
              _MenuRow(
                icon: Icons.help_outline,
                title: 'Helps & Support',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => Scaffold()),
                  );
                },
              ),
              SizedBox(height: 16),

              _MenuRow(
                icon: Icons.privacy_tip_outlined,
                title: 'Privacy policy',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => Scaffold()),
                  );
                },
              ),
              SizedBox(height: 16),

              _MenuRow(
                icon: Icons.description_outlined,
                title: 'Terms & Conditions',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => Scaffold()),
                  );
                },
              ),
            ],
          ),
        ),

        const SizedBox(height: 32),

        _logoutButton(context),
      ],
    );
  }

  // ================= SECTION TITLE =================
  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // ================= GLASS CARD =================
  Widget _glassCard({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 16, 16, 16).withOpacity(0.18),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.25)),
          ),
          child: child,
        ),
      ),
    );
  }

  // ================= LOGOUT =================
  Widget _logoutButton(BuildContext context) {
    return Center(
      child: TextButton.icon(
        onPressed: () => _handleLogout(context),
        icon: const Icon(Icons.logout, color: Colors.red),
        label: const Text(
          'Log out',
          style: TextStyle(
            color: Colors.red,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Future<void> _handleLogout(BuildContext context) async {
    final snackbarNotifier = SnackbarNotifier(context: context);
    final appPigeon = Get.find<AppPigeon>();
    final authInterface = Get.find<AuthInterface>();
    final status = await appPigeon.currentAuth();
    final refreshToken = status is Authenticated
        ? (status.auth.refreshToken ?? status.auth.accessToken ?? '')
        : '';

    if (refreshToken.isNotEmpty) {
      final result = await authInterface.logout(
        param: LogoutRequestModel(refreshToken: refreshToken),
      );
      result.fold(
        (failure) {
          snackbarNotifier.notifyError(
            message:
                failure.uiMessage.isNotEmpty ? failure.uiMessage : 'Logout failed',
          );
        },
        (_) {},
      );
    } else {
      await appPigeon.logOut();
    }

    if (!context.mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }
}

// ================= CONTACT ROW =================
class _ContactRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _ContactRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.white70, size: 28),
        const SizedBox(width: 12),
        Text(text, style: const TextStyle(color: Colors.white, fontSize: 20)),
      ],
    );
  }
}

// ================= MENU ROW =================
class _MenuRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? badge;
  final VoidCallback? onTap;

  const _MenuRow({
    required this.icon,
    required this.title,
    this.badge,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Icon(icon, color: Colors.white70, size: 28),
            const SizedBox(width: 12),

            Expanded(
              child: Text(
                title,
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),

            if (badge != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  badge!,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),

            const SizedBox(width: 8),
            const Icon(Icons.chevron_right, color: Colors.white54),
          ],
        ),
      ),
    );
  }
}
