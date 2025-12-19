import 'dart:ui';
import 'package:dana_bozzetto/moduls/auth/presentation/screen/otp_verify_screen.dart';
import 'package:flutter/material.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final controller = TextEditingController();
  final passwordController = TextEditingController();
  bool rememberMe = false;
  bool obscurePassword = true;
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
                      children: [
                        // Title
                        const Text(
                          "Forget Password",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Subtitle
                        const Text(
                          "Select which contact details should we use to reset your password",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            height: 1.4,
                          ),
                        ),

                        const SizedBox(height: 24),

                        // ============================
                        //   OPTION 1 — EMAIL
                        // ============================
                        _ContactOptionCard(
                          icon: Icons.email_outlined,
                          title: "Via Email",
                          value: "gdg***fsf@azlotv.com",
                          isSelected: true, // ← make selected glow
                        ),

                        const SizedBox(height: 16),

                        // ============================
                        //   OPTION 2 — PHONE
                        // ============================
                        _ContactOptionCard(
                          icon: Icons.phone_outlined,
                          title: "Via Phone",
                          value: "+88017********",
                          isSelected: false,
                        ),

                        const SizedBox(height: 32),

                        // Continue Button
                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OtpVerifyScreen(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF01676C),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: Text(
                              "Continue",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
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

// }
class _ContactOptionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final bool isSelected;

  const _ContactOptionCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white.withOpacity(0.12),
        border: Border.all(
          color: isSelected
              ? Colors.tealAccent.withOpacity(0.6)
              : Colors.white24,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          // Icon box
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white.withOpacity(0.15),
            ),
            child: Icon(icon, color: Colors.white, size: 26),
          ),

          const SizedBox(width: 16),

          // Texts
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
