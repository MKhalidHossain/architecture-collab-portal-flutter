import 'dart:ui';
import 'package:dana_bozzetto/core/common/common/textfield.dart';
import 'package:dana_bozzetto/core/notifiers/snackbar_notifier.dart';
import 'package:dana_bozzetto/core/theme/app_colors.dart';
import 'package:dana_bozzetto/moduls/auth/controller/register_controller.dart';
import 'package:dana_bozzetto/moduls/auth/presentation/screen/email_verify_screen.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final nameController = TextEditingController();
  final employeeIdController = TextEditingController();
  final emailController = TextEditingController();
  final roleController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final List<String> _roleOptions = const ['client', 'team_member'];
  final List<String> _idTypeOptions = const ['Employee ID', 'Client ID'];
  String? _selectedRole;
  String? _selectedIdType;
  late final RegisterScreenController registerController;
  late final SnackbarNotifier snackbarNotifier;

  @override
  void initState() {
    super.initState();
    snackbarNotifier = SnackbarNotifier(context: context);
    registerController = RegisterScreenController(snackbarNotifier);
    _selectedRole = 'team_member';
    _selectedIdType = 'Employee ID';
    roleController.text = _selectedRole!;
    registerController.role = _selectedRole!;
  }

  void _setRole(String? value) {
    if (value == null || value.isEmpty) return;
    setState(() {
      _selectedRole = value;
      _selectedIdType = value == 'client' ? 'Client ID' : 'Employee ID';
    });
    roleController.text = value;
    registerController.role = value;
  }

  void _setIdType(String? value) {
    if (value == null || value.isEmpty) return;
    final role = value == 'Client ID' ? 'client' : 'team_member';
    setState(() {
      _selectedIdType = value;
      _selectedRole = role;
    });
    roleController.text = role;
    registerController.role = role;
  }

  @override
  void dispose() {
    nameController.dispose();
    employeeIdController.dispose();
    emailController.dispose();
    roleController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    registerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/image/ab.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.25),
                        width: 1.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 40,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,

                      children: [
                        Text(
                          "Create New Account",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 16),
                        LabeledTextField(
                          hintText: "Enter Your Name",
                          prefixIcon: Icons.person_outline_rounded,
                          controller: nameController,
                          onChanged: (value) => registerController.name = value,
                        ),
                        LabeledDropdown(
                          hintText: "Select ID Type",
                          items: _idTypeOptions,
                          value: _selectedIdType,
                          onChanged: _setIdType,
                          textSize: 18,
                          textColor: AppColors.white,
                          borderColor: AppColors.textFieldBorder,
                          focusedBorderColor: AppColors.white,
                          borderRadius: 12,
                          backgroundColor: Colors.transparent,
                          hintTextColor: AppColors.textFieldTextiHint,
                          hintTextSize: 18,
                          hintTextWeight: FontWeight.w400,
                          itemTextSize: 18,
                          itemTextColor: Colors.black,
                          selectedItemTextColor: AppColors.white,
                          height: 48,
                          prefixIcon: Icons.badge_outlined,
                          prefixIconColor: Colors.grey,
                          prefixIconSize: 28,
                        ),
                        LabeledTextField(
                          hintText: _selectedIdType == 'Client ID'
                              ? "Enter Client ID"
                              : "Enter Your Employee ID",
                          prefixIcon: Icons.person_outline_rounded,
                          controller: employeeIdController,
                          onChanged: (value) =>
                              registerController.employeeId = value,
                        ),
                        LabeledTextField(
                          hintText: "Enter Email",
                          prefixIcon: Icons.email_outlined,
                          controller: emailController,
                          onChanged: (value) => registerController.email = value,
                        ),
                        LabeledDropdown(
                          hintText: "Select Role",
                          items: _roleOptions,
                          value: _selectedRole,
                          onChanged: _setRole,
                          textSize: 18,
                          textColor: AppColors.white,
                          borderColor: AppColors.textFieldBorder,
                          focusedBorderColor: AppColors.white,
                          borderRadius: 12,
                          backgroundColor: Colors.transparent,
                          hintTextColor: AppColors.textFieldTextiHint,
                          hintTextSize: 18,
                          hintTextWeight: FontWeight.w400,
                          itemTextSize: 18,
                          itemTextColor: Colors.black,
                          selectedItemTextColor: AppColors.white,
                          height: 48,
                          prefixIcon: Icons.badge_outlined,
                          prefixIconColor: Colors.grey,
                          prefixIconSize: 28,
                        ),
                        LabeledTextField(
                          isPassword: true,
                          hintText: "Create Password",
                          prefixIcon: Icons.lock_open_rounded,
                          controller: passwordController,
                          onChanged: (value) =>
                              registerController.password = value,
                        ),
                        LabeledTextField(
                          hintText: "Confirm Password",
                          prefixIcon: Icons.lock_open_rounded,
                          controller: confirmPasswordController,
                          isPassword: true,
                          onChanged: (value) =>
                              registerController.confirmPassword = value,
                        ),

                        const SizedBox(height: 24),

                        AnimatedBuilder(
                          animation: registerController,
                          builder: (context, child) {
                            final canSubmit = registerController.canSubmit &&
                                !registerController.isBusy;
                            return SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: ElevatedButton(
                                onPressed: canSubmit
                                    ? () async {
                                        await registerController.register(
                                          onSuccessNavigate: () {
                                            if (!mounted) return;
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    EmailVerifyScreen(
                                                  email: registerController.email,
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      }
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF01676C),
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: registerController.isBusy
                                    ? const SizedBox(
                                        width: 22,
                                        height: 22,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            Colors.white,
                                          ),
                                        ),
                                      )
                                    : const Text(
                                        'Sign Up',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "you have an account? ",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 15,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                'Sign in',
                                style: TextStyle(
                                  color: Color(0xFF00D4AA),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
