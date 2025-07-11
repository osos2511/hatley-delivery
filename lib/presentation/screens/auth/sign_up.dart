import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hatley_delivery/presentation/cubit/governorate_cubit/governorate_cubit.dart';
import 'package:hatley_delivery/presentation/cubit/governorate_cubit/governorate_state.dart';
import 'package:hatley_delivery/presentation/cubit/zone_cubit/zone_cubit.dart';
import 'package:hatley_delivery/presentation/cubit/zone_cubit/zone_state.dart';
import 'package:hatley_delivery/presentation/screens/auth/app_function.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hatley_delivery/presentation/screens/auth/widgets/custom_auth_button.dart';
import 'package:hatley_delivery/presentation/screens/auth/widgets/custom_text_field.dart';
import 'package:hatley_delivery/presentation/screens/auth/widgets/custom_toast.dart';
import '../../../core/colors_manager.dart';
import '../../../core/routes_manager.dart';
import '../../../injection_container.dart';
import '../../cubit/register_cubit/register_cubit.dart';
import '../../cubit/register_cubit/register_state.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final userNameController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final nationalIdController = TextEditingController();
  final confirmPassController = TextEditingController();

  File? faceImage;
  File? frontIdImage;
  File? backIdImage;

  int? selectedGovernorateId;
  int? selectedZoneId;

  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    userNameController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    emailController.dispose();
    nationalIdController.dispose();
    confirmPassController.dispose();
    super.dispose();
  }

  Future<void> pickImage(ImageSource source, String imageType) async {
    final pickedFile = await _picker.pickImage(source: source, imageQuality: 50);
    if (pickedFile != null) {
      setState(() {
        switch (imageType) {
          case 'face':
            faceImage = File(pickedFile.path);
            break;
          case 'front':
            frontIdImage = File(pickedFile.path);
            break;
          case 'back':
            backIdImage = File(pickedFile.path);
            break;
        }
      });
    }
  }

  void showImagePicker(String imageType) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take Photo'),
                onTap: () {
                  Navigator.pop(context);
                  pickImage(ImageSource.camera, imageType);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  pickImage(ImageSource.gallery, imageType);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  String? validateConfirmPassword(String? value) {
    if (value != passwordController.text) {
      return "Passwords do not match";
    }
    return null;
  }

  bool validateImages() {
    if (faceImage == null || frontIdImage == null || backIdImage == null) {
      CustomToast.show(message: "Please upload all required images");
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<RegisterCubit>()),
        BlocProvider(create: (context) => sl<GovernorateCubit>()..fetchGovernorates()),
        BlocProvider(create: (context) => sl<ZoneCubit>()),
      ],
      child: Scaffold(
        body: SizedBox(
          width: double.infinity,
          height: screenSize.height,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Create Your Account',
                  style: GoogleFonts.exo2(
                    color: ColorsManager.buttonColorApp,
                    fontSize: 26.sp,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        offset: const Offset(0, 1),
                        blurRadius: 2,
                        color: ColorsManager.blackShadow,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  'Sign up to get started',
                  style: GoogleFonts.exo2(
                    color: ColorsManager.white70,
                    fontSize: 16.sp,
                  ),
                ),
                SizedBox(height: 30.h),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomTextField(
                        keyboardType: TextInputType.name,
                        controller: userNameController,
                        hint: "Your name",
                        icon: Icons.person_outline,
                        validator: AppFunction.validateName,
                      ),
                      SizedBox(height: 20.h),
                      CustomTextField(
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
                        hint: "Email Address",
                        icon: Icons.email,
                        validator: AppFunction.validateEmail,
                      ),
                      SizedBox(height: 20.h),
                      CustomTextField(
                        keyboardType: TextInputType.phone,
                        controller: phoneController,
                        hint: "Phone Number",
                        icon: Icons.phone,
                        validator: AppFunction.validatePhone,
                      ),
                      SizedBox(height: 20.h),
                      CustomTextField(
                        keyboardType: TextInputType.number,
                        controller: nationalIdController,
                        hint: "National ID",
                        icon: Icons.badge_outlined,
                        validator: AppFunction.validateNationalId,
                      ),
                      SizedBox(height: 20.h),
                      CustomTextField(
                        keyboardType: TextInputType.text,
                        controller: passwordController,
                        hint: "Password",
                        icon: Icons.lock_outline,
                        isPassword: true,
                        validator: AppFunction.validatePassword,
                      ),
                      SizedBox(height: 20.h),
                      CustomTextField(
                        keyboardType: TextInputType.text,
                        controller: confirmPassController,
                        hint: "Confirm Password",
                        icon: Icons.lock,
                        isPassword: true,
                        validator: validateConfirmPassword,
                      ),
                      SizedBox(height: 30.h),

                      /// Governorate Dropdown
                      /// Governorate Dropdown
                      BlocBuilder<GovernorateCubit, GovernorateState>(
                        builder: (context, state) {
                          return DropdownButtonFormField<int>(
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white70),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white70),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            dropdownColor: Colors.grey[900],
                            iconEnabledColor: Colors.white,
                            hint: Text(
                              "Select Governorate",
                              style: TextStyle(color: Colors.white70),
                            ),
                            value: selectedGovernorateId,
                            items: (state is GovernorateLoaded)
                                ? state.governorates
                                .map(
                                  (gov) => DropdownMenuItem(
                                value: gov.id,
                                child: Text(
                                  gov.name,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            )
                                .toList()
                                : [],
                            onChanged: (state is GovernorateLoaded)
                                ? (value) {
                              setState(() {
                                selectedGovernorateId = value;
                                selectedZoneId = null;
                              });
                              context.read<ZoneCubit>().fetchZones(govName: value.toString());
                            }
                                : null,
                            validator: (value) =>
                            value == null ? "Please select a governorate" : null,
                          );
                        },
                      ),

                      SizedBox(height: 20.h),

                      /// Zone Dropdown
                      BlocBuilder<ZoneCubit, ZoneState>(
                        builder: (context, state) {
                          return DropdownButtonFormField<int>(
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white70),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white70),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            dropdownColor: Colors.grey[900],
                            iconEnabledColor: Colors.white,
                            hint: Text(
                              "Select Zone",
                              style: TextStyle(color: Colors.white70),
                            ),
                            value: selectedZoneId,
                            items: (state is ZonesLoaded)
                                ? state.zones
                                .map(
                                  (zone) => DropdownMenuItem(
                                value: zone.zoneId,
                                child: Text(
                                  zone.name,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            )
                                .toList()
                                : [],
                            onChanged: (state is ZonesLoaded)
                                ? (value) {
                              setState(() {
                                selectedZoneId = value;
                              });
                            }
                                : null,
                            validator: (value) => value == null ? "Please select a zone" : null,
                          );
                        },
                      ),


                      SizedBox(height: 30.h),
                      buildImagePicker("Front ID Image", frontIdImage, "front"),
                      SizedBox(height: 15.h),
                      buildImagePicker("Back ID Image", backIdImage, "back"),
                      SizedBox(height: 15.h),
                      buildImagePicker("Selfie with ID", faceImage, "face"),

                      SizedBox(height: 30.h),
                      BlocConsumer<RegisterCubit, RegisterState>(
                        listener: (context, state) {
                          if (state is RegisterSuccess) {
                            Navigator.pushReplacementNamed(
                                context, RoutesManager.signInRoute);
                          } else if (state is RegisterFailure) {
                            CustomToast.show(
                              message: "Registration failed. Please try again.",
                            );
                          }
                        },
                        builder: (context, state) {
                          final isLoading = state is RegisterLoading;

                          return CustomAuthButton(
                            text: 'Sign Up',
                            isLoading: isLoading,
                            onPressed: isLoading
                                ? null
                                : () {
                              if (_formKey.currentState!.validate() &&
                                  validateImages()) {
                                context.read<RegisterCubit>().register(
                                  userName: userNameController.text.trim(),
                                  email: emailController.text.trim(),
                                  phone: phoneController.text.trim(),
                                  national_id:
                                  nationalIdController.text.trim(),
                                  password: passwordController.text.trim(),
                                  faceImage: faceImage!.path,
                                  frontImage: frontIdImage!.path,
                                  backImage: backIdImage!.path,
                                  Zone_ID: selectedZoneId!,
                                  Governorate_ID: selectedGovernorateId!,
                                );
                              }
                            },
                          );
                        },
                      ),
                      SizedBox(height: 20.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account? ",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                RoutesManager.signInRoute,
                              );
                            },
                            child: Text(
                              "Sign In",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildImagePicker(String label, File? image, String imageType) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.exo2(
            color: Colors.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8.h),
        GestureDetector(
          onTap: () => showImagePicker(imageType),
          child: Container(
            width: double.infinity,
            height: 150.h,
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white70),
            ),
            child: image != null
                ? ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(image, fit: BoxFit.cover),
            )
                : Center(
              child: Icon(
                Icons.add_a_photo,
                color: Colors.white70,
                size: 40.sp,
              ),
            ),
          ),
        ),
      ],
    );
  }
}