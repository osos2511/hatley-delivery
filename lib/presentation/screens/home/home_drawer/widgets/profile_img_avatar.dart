import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../core/colors_manager.dart';
import '../../../../cubit/profile_cubit/profile_cubit.dart';

class ProfileImgAvatar extends StatelessWidget {
  final String imageUrl;
  final double size; // تحكم في الحجم هنا

  const ProfileImgAvatar({super.key, required this.imageUrl, this.size = 120});

  String get fixedImageUrl {
    if (imageUrl.startsWith('https:/') && !imageUrl.startsWith('https://')) {
      return imageUrl.replaceFirst('https:/', 'https://');
    }
    if (imageUrl.startsWith('http:/') && !imageUrl.startsWith('http://')) {
      return imageUrl.replaceFirst('http:/', 'http://');
    }
    return imageUrl;
  }

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source, imageQuality: 75);

    if (pickedFile != null) {
      final imageFile = File(pickedFile.path);
      // استدعاء الكوبيوت لرفع الصورة
      context.read<ProfileCubit>().uploadProfileImage(imageFile);
    }
  }

  void _showImagePickerOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Take Photo'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(context, ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(context, ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isNetworkImage =
        fixedImageUrl.startsWith('http://') ||
        fixedImageUrl.startsWith('https://');

    return Stack(
      children: [
        ClipOval(
          child: SizedBox(
            width: size,
            height: size,
            child:
                isNetworkImage
                    ? Image.network(
                      fixedImageUrl,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (context, error, stackTrace) => Image.asset(
                            'assets/person.png',
                            fit: BoxFit.cover,
                          ),
                    )
                    : Image.asset(imageUrl, fit: BoxFit.cover),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 4,
          child: GestureDetector(
            onTap: () => _showImagePickerOptions(context),
            child: CircleAvatar(
              radius: size * 0.17, // حجم زر الكاميرا نسبة للـ avatar
              backgroundColor: ColorsManager.buttonColorApp,
              child: const Icon(
                Icons.camera_alt,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
