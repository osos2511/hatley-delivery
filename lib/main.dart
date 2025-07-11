import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hatley_delivery/presentation/cubit/auth_cubit/auth_cubit.dart';
import 'package:hatley_delivery/presentation/cubit/navigation_cubit.dart';
// import 'package:hatley/core/colors_manager.dart';
// import 'package:hatley/presentation/cubit/feedback_cubit/feedback_cubit.dart';
// import 'package:hatley/presentation/cubit/auth_cubit/auth_cubit.dart';
// import 'package:hatley/presentation/cubit/make_orders_cubit/make_orders_cubit.dart';
// import 'package:hatley/presentation/cubit/navigation_cubit.dart';
// import 'presentation/cubit/tracking_cubit/tracking_cubit.dart';
import 'core/colors_manager.dart';
import 'core/local/token_storage.dart';
import 'core/routes_manager.dart';
import 'injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setupGetIt();

  final tokenStorage = sl<TokenStorage>();
  final token = await tokenStorage.getToken();
  final expirationStr = await tokenStorage.getExpiration();

  String initialRoute;

  if (token != null && expirationStr != null) {
    final expiration = DateTime.tryParse(expirationStr);
    final now = DateTime.now().toUtc();
    if (expiration != null && now.isBefore(expiration)) {
      initialRoute = RoutesManager.homeRoute;
    } else {
      await tokenStorage.clearToken();
      initialRoute = RoutesManager.splashRoute;
    }
  } else {
    initialRoute = RoutesManager.splashRoute;
  }

  runApp(DevicePreview(
      enabled: true,
      builder:(context) =>  MyApp(initialRoute: initialRoute)));
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 912),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => NavigationCubit()),
          //BlocProvider(create: (context) => sl<MakeOrderCubit>()),
          BlocProvider(create: (context) => sl<AuthCubit>()),
          //BlocProvider(create: (context) => sl<TrackingCubit>()),
          //BlocProvider(create: (context) => sl<FeedbackCubit>()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          onGenerateRoute: RoutesManager.router,
          initialRoute: initialRoute,
          theme: ThemeData(scaffoldBackgroundColor: ColorsManager.primaryColorApp),
        ),
      ),
    );
  }
}
