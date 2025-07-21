import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hatley_delivery/core/colors_manager.dart';

class ContactUs extends StatelessWidget {
  const ContactUs({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        padding: REdgeInsets.all(20),
        child: Column(
          children: [
            Icon(
              Icons.mark_email_read,
              size: 100.sp,
              color: ColorsManager.white,
            ),
            SizedBox(height: 16.h),
            Text(
              'If you have questions or just want to get in touch, use the form below.\nWe look forward to hearing from you!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.sp,
                height: 1.5.h,
                color: ColorsManager.white70,
              ),
            ),
            SizedBox(height: 24.h),

            // Input Fields
            _buildTextField(label: 'Name', icon: Icons.person),
            SizedBox(height: 12.h),
            _buildTextField(label: 'Email', icon: Icons.email),
            SizedBox(height: 12.h),
            _buildTextField(label: 'Phone', icon: Icons.phone),
            SizedBox(height: 12.h),
            _buildTextField(
              label: 'Enter your message',
              icon: Icons.message,
              maxLines: 4,
            ),
            SizedBox(height: 16.h),

            // Send Button
            ElevatedButton(
              onPressed: () {
                // Action
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorsManager.buttonColorApp,
                minimumSize: Size(screenSize.width * 0.7, 55),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text(
                "Send",
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    int maxLines = 1,
  }) {
    return TextField(
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
      ),
    );
  }
}
