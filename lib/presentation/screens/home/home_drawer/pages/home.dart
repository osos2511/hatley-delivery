import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hatley_delivery/presentation/cubit/order_cubit/getAllOrders_cubit.dart';
import 'package:hatley_delivery/presentation/cubit/order_cubit/order_state.dart';
import 'package:hatley_delivery/domain/usecases/get_related_orders_usecase.dart';
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
import 'about_us.dart';
import 'our_team.dart';
import '../../../../cubit/profile_cubit/profile_cubit.dart';
import '../../../../cubit/profile_cubit/profile_state.dart';
import 'package:signalr_netcore/signalr_client.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GetRelatedOrdersCubit>(
      create: (context) =>
          GetRelatedOrdersCubit(sl<GetRelatedOrdersUseCase>())
            ..getRelatedOrders(),
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

  // SignalR variables
  late final HubConnection _hubConnection;
  static const String _serverUrl =
      "https://hatley.runasp.net/NotifyOfAcceptOrDeclineForDeliveryOffer";

  @override
  void initState() {
    super.initState();
    _startSignalRConnection();
  }

  Future<void> _startSignalRConnection() async {
    _hubConnection = HubConnectionBuilder()
        .withUrl(
          _serverUrl,
          options: HttpConnectionOptions(
            transport: HttpTransportType.WebSockets,
          ),
        )
        .withAutomaticReconnect()
        .build();

    _hubConnection.onclose(({Exception? error}) {});
    _hubConnection.onreconnecting(({Exception? error}) {});

    try {
      await _hubConnection.start();
      _registerSignalRListeners();
    } catch (e) {
      print("Error connecting to SignalR: $e");
    }
  }

  void _registerSignalRListeners() {
    _hubConnection.on("NotifyOfAcceptOrDeclineForDeliveryOffer", (arguments) {
      print("SignalR arguments: $arguments"); // لطباعة البيانات المستقبلة
      if (arguments != null && arguments.length >= 7) {
        final state = arguments[0];
        final priceOfOffer = arguments[1];
        final orderId = arguments[2];
        final userName = arguments[3];
        final userPhoto = arguments[4];
        final ordersCount = arguments[5];
        final check = arguments[6]; // object فيه email و type

        // يمكنك هنا إضافة تصفية حسب check['email'] أو check['type'] إذا أردت

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

        // BlocListener<TrackingCubit, TrackingState>(
        //   listenWhen: (previous, current) => current is TrackingError,
        //   listener: (context, state) {
        //     if (state is TrackingError) {
        //       WidgetsBinding.instance.addPostFrameCallback((_) {
        //         CustomToast.show(message: "An error occurred while tracking. Please try again.");
        //       });
        //     }
        //   },
        // ),
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
                        appBarTitle = 'My Orders'; // الكلمة الإنجليزية
                        break;
                      case 6:
                        appBarTitle = 'Deliveries'; // الكلمة الإنجليزية
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
                      return const AboutUs();
                    //return const AllTrackingOrdersScreen();
                    case 2:
                      return const OurTeam();
                    //return const ContactUs();
                    // case 3:
                    //   return const AboutUs();
                    // case 3:
                    //   return const OurTeam();
                    // case 5:
                    //   return const MyOrders();
                    // case 6:
                    //   return Deliveries();
                    case 7:
                      return Profile();
                    default:
                      return RefreshIndicator(
                        onRefresh: () async {
                          await context
                              .read<GetRelatedOrdersCubit>()
                              .getRelatedOrders();
                        },
                        child: BlocBuilder<GetRelatedOrdersCubit, OrderState>(
                          builder: (context, state) {
                            if (state is OrderLoading) {
                              return Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              );
                            } else if (state is GetAllOrdersSuccess) {
                              return ListView.builder(
                                itemCount: state.orders.length,
                                itemBuilder: (context, index) {
                                  final order = state.orders[index];
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
