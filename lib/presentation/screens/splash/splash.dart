import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/colors_manager.dart';
import '../../../core/routes_manager.dart';
import '../../cubit/auth_cubit/auth_cubit.dart';
import '../../cubit/auth_cubit/auth_state.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3), () async {
      final authCubit = context.read<AuthCubit>();
      await authCubit.checkTokenAndNavigate();
      if (!mounted) return;

      final state = authCubit.state;

      if (state is TokenValid) {
        Navigator.pushReplacementNamed(context, RoutesManager.homeRoute);
      } else {
        Navigator.pushReplacementNamed(context, RoutesManager.signInRoute);
      }
    });
  }

  double responsiveFontSize(BuildContext context, double baseFontSize) {
    final screenWidth = MediaQuery.of(context).size.width;
    return screenWidth * (baseFontSize / 375);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(),
          Text(
            'HATLEY',
            style: GoogleFonts.rubikVinyl(
              color: ColorsManager.primaryColorApp,
              fontSize: responsiveFontSize(context, 60),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          AnimatedTextKit(
            totalRepeatCount: 1,
            isRepeatingAnimation: false,
            animatedTexts: [
              TyperAnimatedText(
                'Get Anything',
                textStyle: GoogleFonts.exo2(
                  color: ColorsManager.primaryColorApp,
                  fontSize: responsiveFontSize(context, 30),
                  fontWeight: FontWeight.w600,
                ),
                speed: const Duration(milliseconds: 300),
              ),
            ],
            onTap: () {
              print("💬 Get Anything tapped");
            },
          ),
          const Spacer(),
          SpinKitPianoWave(
            color: ColorsManager.primaryColorApp,
            size: screenWidth * 0.08,
          ),
          SizedBox(height: screenHeight * 0.05),
        ],
      ),
    );
  }
}
