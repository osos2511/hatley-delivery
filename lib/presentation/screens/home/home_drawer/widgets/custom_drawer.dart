import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/colors_manager.dart';
import '../../../../../core/missing_fields_dialog.dart';
import '../../../../../core/routes_manager.dart';
import '../../../../cubit/auth_cubit/auth_cubit.dart';
import '../../../../cubit/navigation_cubit.dart';
import 'custom_listTile.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 250.w,
      backgroundColor: ColorsManager.white,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 30.h),
            color: ColorsManager.primaryColorApp,
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40.r,
                  backgroundImage: AssetImage('assets/hatley-logo.png'),
                ),
                SizedBox(height: 10.h),
                Text(
                  'Hatley',
                  style: GoogleFonts.lilyScriptOne(
                    color: Colors.white,
                    fontSize: 25.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                CustomListTile(
                  onPress: () {
                    context.read<NavigationCubit>().changePage(0);
                    Navigator.pop(context);
                  },
                  icon: Icons.home,
                  text: 'Home',
                ),
                CustomListTile(
                  onPress: () {
                    context.read<NavigationCubit>().changePage(1);
                    Navigator.pop(context);
                  },
                  icon: Icons.local_shipping,
                  text: 'Track Orders',
                ),
                CustomListTile(
                  onPress: () {
                    context.read<NavigationCubit>().changePage(2);
                    Navigator.pop(context);
                  },
                  icon: Icons.phone,
                  text: 'Contact Us',
                ),
                CustomListTile(
                  onPress: () {
                    context.read<NavigationCubit>().changePage(3);
                    Navigator.pop(context);
                  },
                  icon: Icons.info_outline,
                  text: 'About Us',
                ),
                CustomListTile(
                  onPress: () {
                    context.read<NavigationCubit>().changePage(4);
                    Navigator.pop(context);
                  },
                  icon: Icons.group,
                  text: 'Our Team',
                ),
                CustomListTile(
                  onPress: () {
                    context.read<NavigationCubit>().changePage(5);
                    Navigator.pop(context);
                  },
                  icon: Icons.shopping_cart,
                  text: 'My Orders',
                ),

                CustomListTile(
                  onPress: () {
                    context.read<NavigationCubit>().changePage(6);
                    Navigator.pop(context);
                  },
                  icon: Icons.star,
                  text: 'Ratings',
                ),
                CustomListTile(
                  onPress: () {
                    context.read<NavigationCubit>().changePage(7);
                    Navigator.pop(context);
                  },
                  icon: Icons.person,
                  text: 'Profile',
                ),

                CustomListTile(
                  onPress: () {
                    showMissingFieldsDialog(
                      context,
                      'Are you sure you want to log out?',
                      onOkPressed: () {
                        context.read<AuthCubit>().logOut();
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          RoutesManager.signInRoute,
                          (route) => false,
                        );
                      },
                    );
                  },
                  icon: Icons.logout,
                  text: 'Logout',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
