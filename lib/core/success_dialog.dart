import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'colors_manager.dart';

void showSuccessDialog(
  BuildContext context,
  String message, {
  String? nextRoute,
  Object? arguments,
  bool showCancelButton = false,
  VoidCallback? onOkPressed, // ← أضف هذا الباراميتر
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder:
        (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.white,
          titlePadding: EdgeInsets.zero,
          title: Container(
            padding:  REdgeInsets.all(16),
            decoration:  BoxDecoration(
             color: ColorsManager.primaryColorApp,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Container(
              padding:  REdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check,
                color: ColorsManager.primaryColorApp,
                size: 24,
              ),
            ),
          ),
          content: Padding(
            padding:  REdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Text(
              message,
              style:  TextStyle(fontSize: 16.sp, color: Colors.black87),
            ),
          ),
          actions: [
            if (showCancelButton)
              Padding(
                padding:  REdgeInsets.only(left: 8, bottom: 8),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    padding:  REdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    elevation: 2,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child:  Text(
                    "Cancel",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
              ),
            Padding(
              padding:  REdgeInsets.only(right: 8, bottom: 8),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:  ColorsManager.primaryColorApp,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  padding:  REdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  elevation: 2,
                ),
                onPressed: () {
                  Navigator.pop(context);
                  if (onOkPressed != null) {
                    onOkPressed();
                  } else if (nextRoute != null) {
                    Navigator.pushReplacementNamed(
                      context,
                      nextRoute,
                      arguments: arguments,
                    );
                  }
                },
                child:  Text(
                  "OK",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
                ),
              ),
            ),
          ],
        ),
  );
}
