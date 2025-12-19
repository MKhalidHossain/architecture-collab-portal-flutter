//  import 'dart:ui';
// import 'package:dana_bozzetto/core/common/common/textfield.dart';
// import 'package:dana_bozzetto/moduls/auth/presentation/screen/forget_password.dart';
// import 'package:flutter/material.dart';

// class OtpVerifyScreen extends StatefulWidget {
//   const OtpVerifyScreen({super.key});

//   @override
//   State<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
// }

// class _OtpVerifyScreenState extends State<OtpVerifyScreen> {
//   final controller = TextEditingController();
//   final passwordController = TextEditingController();
//   bool rememberMe = false;
//   bool obscurePassword = true;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Stack(
//         children: [
//           Container(
//             width: double.infinity,
//             height: double.infinity,
//             decoration: const BoxDecoration(
//               image: DecorationImage(
//                 image: AssetImage('assets/image/ab.png'),
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),

//           Center(
//             child: Padding(
//               padding: const EdgeInsets.all(24.0),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(16),
//                 child: BackdropFilter(
//                   filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
//                   child: Container(
//                     width: double.infinity,
//                     padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
//                     decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(0.12),
//                       borderRadius: BorderRadius.circular(16),
//                       border: Border.all(
//                         color: Colors.white.withOpacity(0.25),
//                         width: 1.2,
//                       ),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.2),
//                           blurRadius: 40,
//                           offset: const Offset(0, 12),
//                         ),
//                       ],
//                     ),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisAlignment: MainAxisAlignment.start,

//                       children: [
//                         Text(
//                           "Login to your account",
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 20,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                         SizedBox(height: 16),
//                         LabeledTextField(
//                           hintText: "Email or Client ID",
//                           prefixIcon: Icons.email_outlined,
//                           controller: TextEditingController(),
//                         ),
//                         LabeledTextField(
//                           hintText: "Password",
//                           prefixIcon: Icons.email_outlined,
//                           controller: TextEditingController(),
//                           isPassword: true,
//                         ),

//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Row(
//                               children: [
//                                 SizedBox(
//                                   width: 20,
//                                   height: 20,
//                                   child: Checkbox(
//                                     value: rememberMe,
//                                     onChanged: (val) {
//                                       setState(() => rememberMe = val!);
//                                     },
//                                     activeColor: const Color(0xFF00695C),
//                                     side: const BorderSide(
//                                       color: Colors.white70,
//                                     ),
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(4),
//                                     ),
//                                   ),
//                                 ),
//                                 const SizedBox(width: 8),
//                                 const Text(
//                                   'Remember me',
//                                   style: TextStyle(
//                                     color: Colors.white70,
//                                     fontSize: 14,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             TextButton(
//                               onPressed: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => ForgetPassword(),
//                                   ),
//                                 );
//                               },
//                               child: const Text(
//                                 'Forgot Password?',
//                                 style: TextStyle(
//                                   color: Colors.white70,
//                                   fontSize: 14,
//                                   decoration: TextDecoration.underline,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),

//                         const SizedBox(height: 24),

//                         SizedBox(
//                           width: double.infinity,
//                           height: 56,
//                           child: ElevatedButton.icon(
//                             onPressed: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => Scaffold(),
//                                 ),
//                               );
//                             },
//                             label: const Text(
//                               'Login',
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Color(0xFF01676C),
//                               foregroundColor: Colors.white,
//                               elevation: 0,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(16),
//                               ),
//                             ),
//                           ),
//                         ),

//                         const SizedBox(height: 20),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             const Text(
//                               "Don't have an account? ",
//                               style: TextStyle(
//                                 color: Colors.white70,
//                                 fontSize: 15,
//                               ),
//                             ),
//                             GestureDetector(
//                               onTap: () {},
//                               child: const Text(
//                                 'Sign up',
//                                 style: TextStyle(
//                                   color: Color(0xFF00D4AA),
//                                   fontWeight: FontWeight.w600,
//                                   fontSize: 15,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // }

import 'dart:ui';
import 'package:dana_bozzetto/moduls/auth/presentation/screen/reset_password-screen.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class OtpVerifyScreen extends StatefulWidget {
  const OtpVerifyScreen({super.key});

  @override
  State<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends State<OtpVerifyScreen> {
  String otp = "";
  int resendTime = 45;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    Future.doWhile(() async {
      if (resendTime == 0) return false;
      await Future.delayed(const Duration(seconds: 1));
      setState(() => resendTime--);
      return true;
    });
  }

  @override
  Widget build(BuildContext context) {
    /// OTP box style
    final defaultPinTheme = PinTheme(
      width: 50,
      height: 50,
      textStyle: const TextStyle(
        fontSize: 22,
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(.35),
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: Colors.white24),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        title: const Text(
          "Enter Security Code",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),

      body: Stack(
        children: [
          /// Background image
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

          /// Glassmorphic Card
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.25),
                        width: 1.2,
                      ),
                    ),

                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        /// Subtitle
                        const Text(
                          "Please check your Email for a message with your code. "
                          "Your code is 6 numbers long.",
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),

                        const SizedBox(height: 20),

                        /// OTP Input
                        Center(
                          child: Pinput(
                            length: 6,
                            obscureText: true,
                            defaultPinTheme: defaultPinTheme,
                            onCompleted: (value) => otp = value,
                          ),
                        ),

                        const SizedBox(height: 16),

                        /// Timer
                        Center(
                          child: Text(
                            "Resend code in ${resendTime}s",
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),

                        /// Continue button
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ResetPasswordscreen(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF01676C),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: const Text(
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
