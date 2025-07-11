import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/colors_manager.dart';

// ignore: must_be_immutable
class CustomListTile extends StatelessWidget {
  CustomListTile({
    super.key,
    required this.icon,
    required this.text,
    required this.onPress,
  });
  IconData icon;
  String text;
  void Function()? onPress;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: ColorsManager.primaryColorApp),
      title: Text(text, style: TextStyle(fontSize: 16.sp)),
      onTap: onPress,
    );
  }
}
