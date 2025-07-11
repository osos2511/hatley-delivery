import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../../core/colors_manager.dart';

class CustomToast {
  static void show({
    required String message,
    Color backgroundColor = ColorsManager.buttonColorApp,
    Color textColor = Colors.white,
    ToastGravity gravity = ToastGravity.BOTTOM,
    Toast toastLength = Toast.LENGTH_LONG,

  }) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: backgroundColor,
      textColor: textColor,
      gravity: gravity,
      toastLength: toastLength,
      fontSize: 16.sp,

    );
  }
}
