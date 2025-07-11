import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'colors_manager.dart';

void showMissingFieldsDialog(
  BuildContext context,
  String message, {
  VoidCallback? onOkPressed,
}) {
  showDialog(
    context: context,
    builder:
        (_) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.white,
          titlePadding: EdgeInsets.zero,
          title: Container(
            padding: const EdgeInsets.all(16),
            decoration:  BoxDecoration(
              color: ColorsManager.buttonColorApp,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child:  Icon(
                Icons.close,
                color: ColorsManager.buttonColorApp,
                size: 24,
              ),
            ),
          ),
          content: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Text(
              message,
              style:  TextStyle(fontSize: 16.sp, color: Colors.black87),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8, bottom: 8),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorsManager.buttonColorApp,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  elevation: 2,
                ),
                onPressed: () {
                  Navigator.of(context).pop(); // غلق الـ dialog
                  if (onOkPressed != null) {
                    onOkPressed();
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
