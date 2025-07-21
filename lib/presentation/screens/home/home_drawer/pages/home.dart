import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hatley_delivery/presentation/cubit/order_cubit/getAllOrders_cubit.dart';
import 'package:hatley_delivery/presentation/cubit/order_cubit/order_state.dart';
import 'package:hatley_delivery/domain/usecases/get_related_orders_usecase.dart';
import 'package:hatley_delivery/presentation/cubit/tracking_cubit/tracking_cubit.dart';
import 'package:hatley_delivery/presentation/cubit/tracking_cubit/tracking_state.dart';
import 'package:hatley_delivery/presentation/screens/auth/widgets/custom_toast.dart';
import 'package:hatley_delivery/presentation/screens/home/home_drawer/pages/about_us.dart';
import 'package:hatley_delivery/presentation/screens/home/home_drawer/pages/all_tracking_orders.dart';
import 'package:hatley_delivery/presentation/screens/home/home_drawer/pages/contact_us.dart';
import 'package:hatley_delivery/presentation/screens/home/home_drawer/pages/profile.dart';
import 'package:hatley_delivery/presentation/screens/home/home_drawer/widgets/custom_order.dart';
import '../../../../../core/colors_manager.dart';
import '../../../../../core/missing_fields_dialog.dart';
import '../../../../../core/routes_manager.dart';
import '../../../../../injection_container.dart';
import '../../../../cubit/auth_cubit/auth_cubit.dart';
import '../../../../cubit/auth_cubit/auth_state.dart';
import '../../../../cubit/navigation_cubit.dart';
import '../widgets/custom_drawer.dart';
import 'our_team.dart';
import '../../../../cubit/profile_cubit/profile_cubit.dart';
import '../../../../cubit/profile_cubit/profile_state.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:hatley_delivery/domain/entities/related_orders_entity.dart';
import 'package:hatley_delivery/core/local/token_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GetAllOrdersCubit>(
      create: (context) => GetAllOrdersCubit(
        sl<GetRelatedOrdersUseCase>(),
        sl<GetUnrelatedOrdersUseCase>(),
      )..getAllOrders(),
      child: const HomeContent(),
    );
  }
}

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  bool _hasCheckedToken = false;
  List<RelatedOrdersEntity> _newOrders = []; // قائمة الطلبات الجديدة

  // SignalR variables
  late final HubConnection _hubConnection;
  static const String _serverUrl =
      "https://hatley.runasp.net/NotifyOfAcceptOrDeclineForDeliveryOffer";
  static const String _newOrdersUrl =
      "https://hatley.runasp.net/NotifyNewOrderForDelivery"; // URL جديد للطلبات الجديدة

  late final TokenStorage _tokenStorage;

  @override
  void initState() {
    super.initState();

    _startSignalRConnection();
  }

  Future<void> _startSignalRConnection() async {
    final prefs = await SharedPreferences.getInstance();
    final tokenStorage = TokenStorageImpl(prefs);
    final token = await tokenStorage.getToken();
    _hubConnection = HubConnectionBuilder()
        .withUrl(
          _newOrdersUrl,
          options: HttpConnectionOptions(
            accessTokenFactory: () async => token ?? '',
            transport: HttpTransportType.WebSockets,
          ),
        )
        .withAutomaticReconnect()
        .build();

    _hubConnection.onclose(({Exception? error}) {});
    _hubConnection.onreconnecting(({Exception? error}) {});

    try {
      await _hubConnection.start();
      print('SignalR connection started successfully');
      _registerSignalRListeners();
    } catch (e) {
      print("Error connecting to SignalR: $e");
    }
  }

  void _registerSignalRListeners() {
    // Listener للرد على العروض
    _hubConnection.on("NotifyOfAcceptOrDeclineForDeliveryOffer", (arguments) {
      print("SignalR arguments: $arguments");
      if (arguments != null && arguments.length >= 7) {
        final state = arguments[0];
        final priceOfOffer = arguments[1];
        final orderId = arguments[2];
        final userName = arguments[3];
        final userPhoto = arguments[4];
        final ordersCount = arguments[5];
        final check = arguments[6];

        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text("Offer Response"),
            content: Text("User has $state your offer for order $orderId"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text("OK"),
              ),
            ],
          ),
        );
      }
    });

    // Listener جديد للطلبات الجديدة
    _hubConnection.on("NotifyOrderForDeliveryHup", (arguments) {
      print("New order received: $arguments");
      if (arguments != null && arguments.length >= 6) {
        final orderData = arguments[0] as Map<dynamic, dynamic>; // order object
        final userName = arguments[1]; // user_Name
        final userPhoto = arguments[2]; // user_photo
        final userOrdersCount = arguments[3]; // user_Orders_Count
        final deliversEmails = arguments[4] as List; // delivers_emails(List)
        final type = arguments[5]; // type

        // تحويل البيانات إلى RelatedOrdersEntity
        final newOrder = RelatedOrdersEntity(
          orderId: orderData['order_id'] ?? 0,
          orderTime: orderData['order_time'] ?? '',
          price: orderData['price'] ?? 0,
          orderDescription: orderData['description'] ?? '',
          orderZoneFrom: orderData['order_zone_from'] ?? '',
          orderCityFrom: orderData['order_city_from'] ?? '',
          detailesAddressFrom: orderData['detailes_address_from'] ?? '',
          orderZoneTo: orderData['order_zone_to'] ?? '',
          orderCityTo: orderData['order_city_to'] ?? '',
          detailesAddressTo: orderData['detailes_address_to'] ?? '',
        );

        // إضافة الطلب الجديد للقائمة
        setState(() {
          _newOrders.insert(0, newOrder); // إضافة في البداية
        });

        // إظهار إشعار للمستخدم
        CustomToast.show(message: 'New order received from $userName!');
      }
    });
  }

  @override
  void dispose() {
    _hubConnection.stop();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasCheckedToken) {
      _hasCheckedToken = true;

      final int? initialPage =
          ModalRoute.of(context)?.settings.arguments as int?;
      if (initialPage != null) {
        context.read<NavigationCubit>().changePage(initialPage);
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<AuthCubit>().checkTokenAndNavigate();
      });
    }
  }

  void _showSessionExpiredDialog() {
    showMissingFieldsDialog(
      context,
      'Your session has expired. Please log in again.',
      onOkPressed: () {
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil(RoutesManager.signInRoute, (route) => false);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthCubit, AuthState>(
          listenWhen: (previous, current) => current is TokenInvalid,
          listener: (context, state) {
            if (state is TokenInvalid) {
              _showSessionExpiredDialog();
            }
          },
        ),

        BlocListener<TrackingCubit, TrackingState>(
          listenWhen: (previous, current) => current is TrackingError,
          listener: (context, state) {
            if (state is TrackingError) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                CustomToast.show(
                  message:
                      "An error occurred while tracking. Please try again.",
                );
              });
            }
          },
        ),
      ],
      child: Column(
        children: [
          // BlocBuilder غير مرئي لتفعيل ProfileCubit
          BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              return const SizedBox.shrink();
            },
          ),
          Expanded(
            child: Scaffold(
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(56.h),
                child: BlocBuilder<NavigationCubit, int>(
                  builder: (context, state) {
                    String appBarTitle;
                    switch (state) {
                      case 1:
                        appBarTitle = 'Track Orders'; // الكلمة الإنجليزية
                        break;
                      case 2:
                        appBarTitle = 'Contact Us'; // الكلمة الإنجليزية
                        break;
                      case 3:
                        appBarTitle = 'About Us'; // الكلمة الإنجليزية
                        break;
                      case 4:
                        appBarTitle = 'Our Team'; // الكلمة الإنجليزية
                        break;
                      case 5:
                        appBarTitle = 'Previous Orders'; // الكلمة الإنجليزية
                        break;
                      case 6:
                        appBarTitle = 'Ratings'; // الكلمة الإنجليزية
                        break;
                      case 7:
                        appBarTitle = 'Profile'; // الكلمة الإنجليزية
                        break;
                      default:
                        appBarTitle = 'Home'; // الكلمة الإنجليزية
                    }

                    return AppBar(
                      title: Text(
                        appBarTitle,
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      centerTitle: true,
                      iconTheme: const IconThemeData(color: Colors.white),
                      backgroundColor: ColorsManager.primaryColorApp,
                    );
                  },
                ),
              ),
              drawer: const CustomDrawer(),
              body: BlocBuilder<NavigationCubit, int>(
                builder: (context, state) {
                  switch (state) {
                    case 1:
                      return const AllTrackingOrdersScreen();
                    case 2:
                      return const ContactUs();
                    case 3:
                      return const AboutUs();
                    case 4:
                      return const OurTeam();
                    // case 5:
                    //   return const MyOrders();
                    // case 6:
                    //   return Deliveries();
                    case 7:
                      return Profile();
                    default:
                      return RefreshIndicator(
                        onRefresh: () async {
                          // مسح الطلبات الجديدة عند التحديث
                          setState(() {
                            _newOrders.clear();
                          });
                          await context
                              .read<GetAllOrdersCubit>()
                              .getAllOrders();
                        },
                        child: BlocBuilder<GetAllOrdersCubit, OrderState>(
                          builder: (context, state) {
                            if (state is OrderLoading) {
                              return Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              );
                            } else if (state is GetAllOrdersSuccess) {
                              // دمج الطلبات الجديدة مع الطلبات الموجودة
                              final allOrders = [
                                ..._newOrders,
                                ...state.orders,
                              ];

                              return ListView.builder(
                                itemCount: allOrders.length,
                                itemBuilder: (context, index) {
                                  final order = allOrders[index];
                                  return CustomOrderWidget(order: order);
                                },
                              );
                            } else if (state is OrderFailure) {
                              return Center(
                                child: Text('Failed to load orders'),
                              );
                            } else {
                              return const SizedBox.shrink();
                            }
                          },
                        ),
                      );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
