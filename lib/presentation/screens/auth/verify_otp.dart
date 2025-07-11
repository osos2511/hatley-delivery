import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hatley_delivery/presentation/screens/auth/widgets/custom_auth_button.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../core/colors_manager.dart';
import '../../../core/routes_manager.dart';

class VerifyOtp extends StatefulWidget {
  const VerifyOtp({super.key});

  @override
  State<VerifyOtp> createState() => _VerifyOtpState();
}

class _VerifyOtpState extends State<VerifyOtp> {
  String otp = "";
  int secondsRemaining = 30;
  Timer? _timer;
  bool enableResend = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _timer?.cancel();
    setState(() {
      secondsRemaining = 30;
      enableResend = false;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining > 0) {
        setState(() {
          secondsRemaining--;
        });
      } else {
        setState(() {
          enableResend = true;
        });
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _handleContinue() async {
    if (otp.length == 4) {
      setState(() {
        isLoading = true;
      });

      await Future.delayed(const Duration(seconds: 1));

      setState(() {
        isLoading = false;
      });
      Navigator.pushNamed(context, RoutesManager.resetPassRoute);

    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: screenSize.height,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 60.h),
                Text(
                  'Email Verification',
                  style: GoogleFonts.exo2(
                    color: ColorsManager.buttonColorApp,
                    fontWeight: FontWeight.bold,
                    fontSize: 22.sp,
                  ),
                ),
                SizedBox(height: 15.h),
                Text(
                  'Enter the 4-digit code',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.exo2(
                    color: ColorsManager.white70,
                    fontSize: 15.sp,
                  ),
                ),
                SizedBox(height: 40.h),

                PinCodeTextField(
                  length: 4,
                  obscureText: true,
                  animationType: AnimationType.fade,
                  keyboardType: TextInputType.number,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(10.r),
                    fieldHeight: 55.h,
                    fieldWidth: 50.w,
                    inactiveColor: Colors.white54,
                    activeColor: Colors.white54,
                    selectedColor: Colors.white54,
                  ),
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  onChanged: (value) {
                    setState(() => otp = value);
                  },
                  appContext: context,
                ),

                SizedBox(height: 25.h),

                Text(
                  enableResend
                      ? "Didn't receive the code? Resend"
                      : "Resend code in $secondsRemaining s",
                  style: TextStyle(
                    color: ColorsManager.white70,
                    fontSize: 14.sp,
                  ),
                ),

                SizedBox(height: 40.h),
                CustomAuthButton(
                  onPressed: isLoading ? null : _handleContinue,
                  text: "Continue",
                  isLoading: isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
