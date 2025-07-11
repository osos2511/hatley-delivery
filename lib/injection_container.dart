import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hatley_delivery/data/datasources/get_related_orders_datasource.dart';
import 'package:hatley_delivery/data/repo_impl/order_repo_impl.dart';
import 'package:hatley_delivery/domain/repo/order_repo.dart';
import 'package:hatley_delivery/domain/usecases/get_related_orders_usecase.dart';
import 'package:hatley_delivery/presentation/cubit/auth_cubit/auth_cubit.dart';
import 'package:hatley_delivery/presentation/cubit/change_pass_cubit/change_pass_cubit.dart';
import 'package:hatley_delivery/presentation/cubit/governorate_cubit/governorate_cubit.dart';
import 'package:hatley_delivery/presentation/cubit/order_cubit/getAllOrders_cubit.dart';
import 'package:hatley_delivery/presentation/cubit/profile_cubit/profile_cubit.dart';
import 'package:hatley_delivery/presentation/cubit/register_cubit/register_cubit.dart';
import 'package:hatley_delivery/presentation/cubit/statistics_cubit/statistics_cubit.dart';
import 'package:hatley_delivery/presentation/cubit/zone_cubit/zone_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/local/token_storage.dart';
import 'core/network.dart';
import 'data/datasources/get_all_governorate_datasource.dart';
import 'data/datasources/get_all_zoneBy_gov_name_datasource.dart';
import 'data/datasources/logout_remote_datasource.dart';
import 'data/datasources/profile_datasource.dart';
import 'data/datasources/register_datasource.dart';
import 'data/datasources/signIn_datasource.dart';
import 'data/repo_impl/location_repo_impl.dart';
import 'data/repo_impl/profile_repo_impl.dart';
import 'data/repo_impl/user_repo_impl.dart';
import 'domain/repo/location_repo.dart';
import 'domain/repo/profile_repo.dart';
import 'domain/repo/user_repo.dart';
import 'domain/usecases/change_passwoed_usecase.dart';
import 'domain/usecases/getAllGovernorate_usecase.dart';
import 'domain/usecases/getAllZoneByGovName_usecase.dart';
import 'domain/usecases/getAll_statistics_usecase.dart';
import 'domain/usecases/get_profile_info_usecase.dart';
import 'domain/usecases/logout_usecase.dart';
import 'domain/usecases/register_usecase.dart';
import 'domain/usecases/signIn_usecase.dart';
import 'domain/usecases/updateProfile_usecase.dart';
import 'domain/usecases/upload_profile_img_usecase.dart';

final sl = GetIt.instance;

Future<void> setupGetIt() async {
  // ✅ SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // ✅ TokenStorage
  sl.registerLazySingleton<TokenStorage>(() => TokenStorageImpl(sl()));

  // ✅ Dio (Async)
  sl.registerLazySingletonAsync<Dio>(() async => await DioFactory.createDio());

  await sl.isReady<Dio>();

  // ✅ Data Sources
  sl.registerLazySingleton<RegisterRemoteDataSource>(
    () => RegisterDataSourceImpl(dio: sl()),
  );
  sl.registerLazySingleton<SignInRemoteDataSource>(
    () => SignInDataSourceImpl(dio: sl()),
  );
  sl.registerLazySingleton<LogOutRemoteDatasource>(
    () => LogOutDatasourceImpl(dio: sl()),
  );
  sl.registerLazySingleton<GetAllGovernorateRemoteDataSource>(
    () => GetAllGovernorateDataSourceImpl(dio: sl()),
  );
  sl.registerLazySingleton<GetAllZoneByGovNameRemoteDataSource>(
    () => GetAllZoneByGovNameDatasourceImpl(dio: sl()),
  );
  sl.registerLazySingleton<ProfileDatasource>(
        () => ProfileDataSourceImpl(dio: sl()),
  );
  sl.registerLazySingleton<GetRelatedOrdersDataSource>(
    () => GetRelatedOrdersDataSourceImpl(dio: sl()),
  );

  // sl.registerLazySingleton<OfferDataSource>(
  //   () => OfferDataSourceImpl(dio: sl()),
  // );
  // sl.registerLazySingleton<GetAllOrdersRemoteDataSource>(
  //   () => GetallOrdersDatasourceImpl(dio: sl()),
  // );

  // sl.registerLazySingleton<DeliveriesDataSource>(
  //   () => DeliveriesDataSourceImpl(sl()),
  // );
  // sl.registerLazySingleton<RatingDataSource>(() => RatingDataSourceImpl(sl()));
  // sl.registerLazySingleton<ReviewDatasource>(() => ReviewDataSourceImpl(sl()));

  // ✅ Repositories
  sl.registerLazySingleton<UserRepo>(() => UserRepoImpl(sl(), sl(), sl()));
   sl.registerLazySingleton<LocationRepo>(() => LocationRepoImpl(sl(), sl()));
   sl.registerLazySingleton<ProfileRepo>(() => ProfileRepoImpl(sl()));
   sl.registerLazySingleton<OrderRepo>(() => OrderRepoImpl(sl()));


  // sl.registerLazySingleton<OrderRepo>(
  //   () => OrderRepoImpl(sl(), sl(), sl(), sl()),
  // );
  // sl.registerLazySingleton<OfferRepo>(() => OfferRepoImpl(sl()));
  // sl.registerLazySingleton<DeliveriesRepo>(() => DeliveriesRepoImpl(sl()));
  // sl.registerLazySingleton<RatingRepo>(() => RatingRepoImpl(sl()));
  // sl.registerLazySingleton<ReviewRepo>(() => ReviewRepoImpl(sl()));

  // ✅ UseCases
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => SignInUseCase(sl(), sl()));
  sl.registerLazySingleton(() => LogOutUseCase(sl()));
   sl.registerLazySingleton(() => GetAllGovernorateUseCase(sl()));
   sl.registerLazySingleton(() => GetAllZoneByGovNameUseCase(sl()));
  sl.registerLazySingleton(() => GetProfileInfoUsecase(sl()));
  sl.registerLazySingleton(() => UploadProfileImgUsecase(sl()));
  sl.registerLazySingleton(() => ChangePasswordUsecase(sl()));
  sl.registerLazySingleton(() => UpdateprofileUsecase(sl()));
  sl.registerLazySingleton(() => GetallStatisticsUsecase(sl()));
  sl.registerLazySingleton(() => GetRelatedOrdersUseCase(sl()));

  // sl.registerLazySingleton(() => GetallordersUseCase(sl()));
  // sl.registerLazySingleton(() => AcceptOfferUseCase(sl()));
  // sl.registerLazySingleton(() => DeclineofferUsecase(sl()));

  // sl.registerLazySingleton(() => GetDeliveriesUsecase(sl()));
  // sl.registerLazySingleton(() => RatingUsecase(sl()));
  // sl.registerLazySingleton(() => ReviewUsecase(sl()));

  // ✅ Cubits
  sl.registerFactory(() => RegisterCubit(sl()));
  sl.registerFactory(() => AuthCubit(sl(), sl(), sl()));
   sl.registerFactory(() => GovernorateCubit(sl()));
   sl.registerFactory(() => ZoneCubit(sl()));
   sl.registerFactory(
     () => ProfileCubit(
       getProfileInfoUseCase: sl(),
       uploadProfileImgUsecase: sl(),
       updateProfileUsecase: sl(),
     ),
   );
   sl.registerFactory(() => ChangePassCubit(sl()));
    sl.registerFactory(() => StatisticsCubit(sl()));
    sl.registerFactory(() => GetRelatedOrdersCubit(sl()));


 //  sl.registerFactory(() => GetAllOrdersCubit(sl()));

 //  sl.registerFactory(() => OfferCubit(sl(), sl()));
 //  sl.registerFactory(() => TrackingCubit(trakingApiManager: sl()));
 //  sl.registerLazySingleton<TrakingApiManager>(
 //    () => TrakingApiManager(dio: sl()),
 //  );

 //  sl.registerFactory(() => DeliveriesCubit(sl()));
 // sl.registerFactory(()=>FeedbackCubit(ratingUsecase: sl(), reviewUsecase: sl()));

  await sl.allReady();
}
