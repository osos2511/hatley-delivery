import 'package:flutter/material.dart';
import 'package:hatley_delivery/presentation/screens/home/home_drawer/pages/all_tracking_orders.dart';
import '../presentation/screens/auth/forgot_password.dart';
import '../presentation/screens/auth/verify_otp.dart';
import '../presentation/screens/auth/reset_password.dart';
import '../presentation/screens/auth/sign_in.dart';
import '../presentation/screens/auth/sign_up.dart';
import '../presentation/screens/home/home_drawer/pages/change_password.dart';
import '../presentation/screens/home/home_drawer/pages/home.dart';
import '../presentation/screens/home/home_drawer/pages/profile.dart';
import '../presentation/screens/splash/splash.dart';

class RoutesManager {
  static const String splashRoute = '/';
  static const String signInRoute = '/signIn';
  static const String signUpRoute = '/SignUp';
  static const String otpRoute = '/otp';
  static const String forgotPassRoute = '/forgotPass';
  static const String resetPassRoute = '/resetPass';
  static const String homeRoute = '/home';
  static const String makeOrdersRoute = '/makeOrders';
  static const String myOrdersRoute = '/myOrder';
  static const String deliveriesRoute = '/deliveries';
  static const String profileRoute = '/Profile';
  static const String trakingRoute = '/traking';
  static const String changePasswordRoute = '/ChangePasswordPage';

  static Route<dynamic>? router(RouteSettings settings) {
    switch (settings.name) {
      case splashRoute:
        {
          return MaterialPageRoute(builder: (context) => const Splash());
        }
      case signUpRoute:
        {
          return MaterialPageRoute(builder: (context) => SignUpScreen());
        }

      case signInRoute:
        {
          return MaterialPageRoute(builder: (context) => SignInScreen());
        }
      case forgotPassRoute:
        {
          return MaterialPageRoute(builder: (context) => ForgotPassword());
        }
      case otpRoute:
        {
          return MaterialPageRoute(builder: (context) => VerifyOtp());
        }
      case resetPassRoute:
        {
          return MaterialPageRoute(builder: (context) => ResetPass());
        }
      case homeRoute:
        {
          return MaterialPageRoute(
            settings: settings,
            builder: (context) => Home(),
          );
        }

      // case deliveriesRoute:
      //   {
      //     return MaterialPageRoute(builder: (context) => Deliveries());
      //   }
      case profileRoute:
        {
          return MaterialPageRoute(builder: (context) => Profile());
        }
      case trakingRoute:
        {
          return MaterialPageRoute(
            builder: (context) => AllTrackingOrdersScreen(),
          );
        }
      case changePasswordRoute:
        {
          return MaterialPageRoute(
            builder: (context) => const ChangePasswordPage(),
          );
        }
    }
    return null;
  }
}
