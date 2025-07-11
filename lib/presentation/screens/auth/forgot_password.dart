import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hatley_delivery/presentation/screens/auth/widgets/custom_auth_button.dart';
import 'package:hatley_delivery/presentation/screens/auth/widgets/custom_text_field.dart';
import '../../../core/colors_manager.dart';
import '../../../core/routes_manager.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future<void> _handleSendCode() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      await Future.delayed(const Duration(seconds: 1));

      setState(() {
        isLoading = false;
      });
      Navigator.pushReplacementNamed(
        context,
        RoutesManager.otpRoute,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;

    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: screenSize.height,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              left: screenWidth * 0.05,
              right: screenWidth * 0.05,
              top: screenHeight * 0.08,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(
                    "Enter your email address to receive a reset code",
                    style: GoogleFonts.exo2(
                      fontSize: 20.sp,
                      color: ColorsManager.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                   SizedBox(height: 30.h),
                  CustomTextField(
                    icon: Icons.email,
                    hint: 'Email',
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Email is required";
                      } else if (!RegExp(
                        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                      ).hasMatch(value)) {
                        return "Enter a valid email address";
                      }
                      return null;
                    },
                  ),
                   SizedBox(height: 40.h),
                  CustomAuthButton(
                    onPressed: isLoading ? null : _handleSendCode,
                    text: 'Send Code',
                    isLoading: isLoading,
                  ),

                   SizedBox(height: 20.h),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Back to Login",
                      style: TextStyle(color: ColorsManager.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
