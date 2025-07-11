import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/colors_manager.dart';
import '../../../../../injection_container.dart';
import '../../../../cubit/change_pass_cubit/change_pass_cubit.dart';
import '../../../../cubit/change_pass_cubit/change_pass_state.dart';
import '../../../auth/widgets/custom_button.dart';
import '../../../auth/widgets/custom_toast.dart';
import '../widgets/change_pass_field.dart';
class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  late TextEditingController oldPasswordController;
  late TextEditingController newPasswordController;

  @override
  void initState() {
    super.initState();
    oldPasswordController = TextEditingController();
    newPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ChangePassCubit>(),
      child: BlocConsumer<ChangePassCubit, ChangePassState>(
        listener: (context, state) {
          if (state is ChangePassSuccess) {
            CustomToast.show(message: 'Password changed successfully!');
            Navigator.of(context).pop();
          } else if (state is ChangePassFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
          }
        },
        builder: (context, state) {
          final isLoading = state is ChangePassLoading;

          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: Text(
                'Change Password',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
              backgroundColor: ColorsManager.primaryColorApp,
              iconTheme: const IconThemeData(color: Colors.white),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  PasswordTextField(
                    controller: oldPasswordController,
                    hint: 'Old Password',
                    validator: (value) {
                      if (value == null || value.length < 6) {
                        return "Password must be at least 6 characters";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  PasswordTextField(
                    controller: newPasswordController,
                    hint: 'New Password',
                    validator: (value) {
                      if (value == null || value.length < 6) {
                        return "Password must be at least 6 characters";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 40),
                  CustomButton(
                    onPressed:
                        isLoading
                            ? () {}
                            : () {
                              final oldPass = oldPasswordController.text.trim();
                              final newPass = newPasswordController.text.trim();
                              if (oldPass.isEmpty || newPass.isEmpty) {
                                CustomToast.show(message: 'Please fill all fields');

                                return;
                              }
                              FocusScope.of(context).unfocus();
                              context.read<ChangePassCubit>().changePassword(
                                oldPass,
                                newPass,
                              );
                            },
                    text: isLoading ? 'Loading...' : 'Confirm Password',

                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
