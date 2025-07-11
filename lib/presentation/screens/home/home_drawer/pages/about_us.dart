import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/colors_manager.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:  [
            Text(
              'At Hatley, we\'re all about delivering convenience to your doorstep. We understand that time is precious, and that\'s why we\'ve created a platform that puts the power in your hands.\n\n'
                  'You can place your order, choose from a variety of delivery offers, and enjoy a hassle-free delivery experience.\n\n'
                  'Your satisfaction is our priority, and we\'re here to make your life easier, one delivery at a time.',
              style: TextStyle(
                fontSize: 18.sp,
                color: ColorsManager.white70
              ),
            ),

            SizedBox(
              height: 20.h,
            ),
            Image.asset('assets/about-us.png'),
          ],
        ),
      ),
    );
  }
}
