import 'package:flutter/material.dart';

import '../../../../core/colors_manager.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  // final Color bgColor;
  // final Color foColor;


  const CustomButton({
    super.key,
    required this.onPressed,
    required this.text,
    // required this.foColor,
    // required this.bgColor
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorsManager.buttonColorApp,
        foregroundColor: ColorsManager.white,
        minimumSize: Size(screenSize.width * 0.7, 55),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
