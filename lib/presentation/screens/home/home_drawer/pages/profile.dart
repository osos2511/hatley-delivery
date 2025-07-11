import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/colors_manager.dart';
import '../../../../../core/routes_manager.dart';
import '../../../../../injection_container.dart';
import '../../../../cubit/governorate_cubit/governorate_cubit.dart';
import '../../../../cubit/profile_cubit/profile_cubit.dart';
import '../../../../cubit/profile_cubit/profile_state.dart';
import '../../../../cubit/statistics_cubit/statistics_cubit.dart';
import '../../../../cubit/statistics_cubit/statistics_state.dart';
import '../../../../cubit/zone_cubit/zone_cubit.dart';
import '../../../auth/widgets/custom_button.dart';
import '../widgets/profile_img_avatar.dart';
import '../widgets/profile_info_tile.dart';
import '../widgets/edit_profile_dialog.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  int? selectedGovernorateId;
  int? selectedZoneId;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<ProfileCubit>()..getProfileInfo()),
        BlocProvider(create: (_) => sl<StatisticsCubit>()..getAllStatistics()),
        BlocProvider(create: (context) => sl<GovernorateCubit>()..fetchGovernorates()),
        BlocProvider(create: (context) => sl<ZoneCubit>()), // تهيئة ZoneCubit
      ],
      child: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, profileState) {
          if (profileState.isLoadingProfile) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator(color: Colors.white,)),
            );
          }

          if (profileState.errorMessage != null) {
            return Scaffold(
              body: Center(
                child: Text(
                  profileState.errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            );
          }

          if (profileState.profile == null) {
            return const Scaffold(
              body: Center(child: Text("لا توجد بيانات ملف شخصي متاحة")),
            );
          }

          final profile = profileState.profile!;

          // تهيئة selectedGovernorateId و selectedZoneId من بيانات الملف الشخصي
          // إذا لم يتم تعيينهما بواسطة تفاعل المستخدم بعد.
          if (selectedGovernorateId == null && profile.governorateId != null) { // Use profile.governorateId
            selectedGovernorateId = profile.governorateId; // Use profile.governorateId
            // إذا كانت هناك محافظة حالية، قم بجلب المناطق المرتبطة بها لتهيئة dropdown المناطق
            if (profile.governorateId != null) { // Use profile.governorateId
              // تأخير بسيط لضمان أن الـ Cubit جاهز
              WidgetsBinding.instance.addPostFrameCallback((_) {
                // IMPORTANT: Pass govId as int, not govName as String
                context.read<ZoneCubit>().fetchZones(govName: profile.governorateId.toString()); // Corrected
              });
            }
          }
          if (selectedZoneId == null && profile.zoneId != null) { // Use profile.zoneId
            selectedZoneId = profile.zoneId; // Use profile.zoneId
          }

          return BlocBuilder<StatisticsCubit, StatisticsState>(
            builder: (context, statsState) {
              Widget statsWidget;
              double rating = 0.0;

              if (statsState is StatisticsLoading) {
                statsWidget = const Center(child: CircularProgressIndicator());
              } else if (statsState is StatisticsLoaded) {
                final stats = statsState.statistics;
                rating = stats.rate;

                statsWidget = Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  alignment: WrapAlignment.center,
                  children: [
                    _buildStatItem(
                      'Total Orders',
                      stats.totalOrders.toString(),
                    ),
                    _buildStatItem(
                      'Completed Orders',
                      stats.completeOrders.toString(),
                    ),
                    _buildStatItem(
                      'Incomplete Orders',
                      stats.incompleteOrders.toString(),
                    ),
                    _buildStatItem('Pending Orders', stats.pending.toString()),
                    _buildStatItem(
                      'Orders last 30 days',
                      stats.ordersLast30Days.toString(),
                    ),
                  ],
                );
              } else if (statsState is StatisticsError) {
                statsWidget = Center(
                  child: Text(
                    statsState.message,
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              } else {
                statsWidget = const SizedBox.shrink();
              }

              return Scaffold(
                body: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Center(
                      child: Column(
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              ProfileImgAvatar(
                                imageUrl:
                                profile.photo?.isNotEmpty == true
                                    ? profile.photo!
                                    : 'assets/person.png',
                                size: 120,
                              ),
                              if (profileState.isUploadingImage)
                                const Positioned(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(height: 12.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 35.sp,
                              ),
                              SizedBox(width: 5.w),
                              Text(
                                rating.toStringAsFixed(2),
                                style: TextStyle(
                                  color: ColorsManager.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24.sp,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20.h),
                          ProfileInfoTile(
                            label: 'username',
                            value: profile.name??'',
                          ),
                          ProfileInfoTile(label: 'email', value: profile.email??''),
                          ProfileInfoTile(label: 'phone', value: profile.phone??''),
                          ProfileInfoTile(label: 'national_id', value: profile.nationalId??''),
                          ProfileInfoTile(label: 'governorate_name', value: profile.governorateName??''),
                          ProfileInfoTile(label: 'zone_name', value: profile.zoneName??''),
                          SizedBox(height: 20.h),
                          statsWidget,
                          SizedBox(height: 40.h),
                          CustomButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (dialogContext) => MultiBlocProvider(
                                  providers: [
                                    // توفير هذه الـ Cubits لـ dialog
                                    BlocProvider.value(value: context.read<GovernorateCubit>()),
                                    BlocProvider.value(value: context.read<ZoneCubit>()),
                                  ],
                                  child: EditProfileDialog(
                                    currentName: profile.name ?? '',
                                    currentEmail: profile.email ?? '',
                                    currentPhone: profile.phone ?? '',
                                    currentNationalId: profile.nationalId ?? '',
                                    currentGovern: profile.governorateId, // Corrected to currentGovernId: profile.governorateId
                                    currentZone: profile.zoneId,               // Corrected to currentZoneId: profile.zoneId
                                    onSave: (name, email, phone, nationalId, governorateId, zoneId) {
                                      context.read<ProfileCubit>().updateProfile(
                                        name,
                                        email,
                                        phone,
                                        nationalId,
                                        governorateId!, // Make sure these are non-null if cubit expects non-null
                                        zoneId!,         // Make sure these are non-null if cubit expects non-null
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                            text: 'Update Profile',
                          ),
                          SizedBox(height: 10.h),
                          CustomButton(
                            onPressed: () {
                              Navigator.of(
                                context,
                              ).pushNamed(RoutesManager.changePasswordRoute);
                            },
                            text: 'Change Password',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildStatItem(String title, String value) {
    return SizedBox(
      width: 140,
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: ColorsManager.black,
              fontWeight: FontWeight.bold,
              fontSize: 22.sp,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(color: ColorsManager.white, fontSize: 14.sp),
          ),
        ],
      ),
    );
  }
}