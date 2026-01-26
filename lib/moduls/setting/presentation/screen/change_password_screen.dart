import 'dart:ui';
import 'package:dana_bozzetto/core/notifiers/snackbar_notifier.dart';
import 'package:dana_bozzetto/moduls/auth/interface/auth_interface.dart';
import 'package:dana_bozzetto/moduls/auth/model/change_password_request_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  bool showOld = false;
  bool showNew = false;
  bool showConfirm = false;
  bool _isSubmitting = false;

  final oldController = TextEditingController();
  final newController = TextEditingController();
  final confirmController = TextEditingController();

  @override
  void dispose() {
    oldController.dispose();
    newController.dispose();
    confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: const Color(0xFF858583),
        elevation: 0,
        leading: const BackButton(color: Colors.white),
        title: const Text(
          'Change Password',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SizedBox.expand(
        child: Stack(
          children: [
            // Full screen background image
            Positioned.fill(
        child: Image.asset(
          'assets/image/ab.png',
          fit: BoxFit.cover, // ensures full screen coverage
        ),
            ),
            // Content on top of background
            SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: _glassCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _PasswordField(
                label: 'Password',
                controller: oldController,
                obscure: !showOld,
                onToggle: () => setState(() => showOld = !showOld),
              ),
              const SizedBox(height: 16),
              _PasswordField(
                label: 'New Password',
                controller: newController,
                obscure: !showNew,
                onToggle: () => setState(() => showNew = !showNew),
              ),
              const SizedBox(height: 16),
              _PasswordField(
                label: 'Confirm Password',
                controller: confirmController,
                obscure: !showConfirm,
                onToggle: () => setState(() => showConfirm = !showConfirm),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF01676C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _isSubmitting ? null : _handleChangePassword,
                  child: _isSubmitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Save Changes',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
            ),
          ],
        ),
      ),

    );
  }

  Future<void> _handleChangePassword() async {
    final notifier = SnackbarNotifier(context: context);
    final oldPassword = oldController.text.trim();
    final newPassword = newController.text.trim();
    final confirmPassword = confirmController.text.trim();

    if (oldPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      notifier.notifyError(message: 'Please fill all password fields.');
      return;
    }
    if (newPassword != confirmPassword) {
      notifier.notifyError(message: 'New password and confirm do not match.');
      return;
    }

    setState(() => _isSubmitting = true);
    final authInterface = Get.find<AuthInterface>();
    final result = await authInterface.changePassword(
      param: ChangePasswordRequestModel(
        oldPassword: oldPassword,
        newPassword: newPassword,
      ),
    );
    if (!mounted) return;
    result.fold(
      (failure) {
        notifier.notifyError(
          message: failure.uiMessage.isNotEmpty
              ? failure.uiMessage
              : failure.fullError,
        );
      },
      (success) {
        notifier.notifySuccess(message: success.message);
        oldController.clear();
        newController.clear();
        confirmController.clear();
        Navigator.pop(context);
      },
    );
    if (mounted) {
      setState(() => _isSubmitting = false);
    }
  }

  /// ================= GLASS CARD =================
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

class _PasswordField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool obscure;
  final VoidCallback onToggle;

  const _PasswordField({
    required this.label,
    required this.controller,
    required this.obscure,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 16)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.12),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.25)),
          ),
          child: Row(
            children: [
              const Icon(Icons.lock_outline, color: Colors.white70),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: controller,
                  obscureText: obscure,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: '********',
                    hintStyle: TextStyle(color: Colors.white54),
                  ),
                ),
              ),
              IconButton(
                onPressed: onToggle,
                icon: Icon(
                  obscure
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
