// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:hatley/presentation/cubit/tracking_cubit/tracking_state.dart';
// import 'package:hatley/data/model/traking_response.dart';
// import 'package:hatley/core/local/token_storage.dart';
// import 'package:hatley/injection_container.dart';
// import 'package:hatley/presentation/screens/auth/widgets/custom_toast.dart';
// import 'package:signalr_netcore/signalr_client.dart';
// import '../../../../cubit/tracking_cubit/tracking_cubit.dart';
// import '../widgets/track_order_widget.dart';
// import '../widgets/show_rating_dialog.dart';
//
// class AllTrackingOrdersScreen extends StatefulWidget {
//   const AllTrackingOrdersScreen({super.key});
//
//   @override
//   State<AllTrackingOrdersScreen> createState() =>
//       _AllTrackingOrdersScreenState();
// }
//
// class _AllTrackingOrdersScreenState extends State<AllTrackingOrdersScreen> {
//   HubConnection? hubConnection;
//   bool _isSignalRInitialized = false;
//
//   @override
//   void initState() {
//     super.initState();
//     context.read<TrackingCubit>().getTrackingData();
//     _initializeSignalR();
//   }
//
//   @override
//   void dispose() {
//     hubConnection?.stop();
//     super.dispose();
//   }
//
//   Future<void> _initializeSignalR() async {
//     if (_isSignalRInitialized) return;
//
//     final hubUrl = "https://hatley.runasp.net/NotifyChangeStatusForUser";
//     final TokenStorage tokenStorage = sl<TokenStorage>();
//     final userToken = await tokenStorage.getToken();
//     final userEmail = await tokenStorage.getEmail();
//
//     if (userToken == null) {
//       print("Error: User token is null. Cannot initialize SignalR.");
//       return;
//     }
//
//     hubConnection = HubConnectionBuilder()
//         .withUrl(
//       hubUrl,
//       options: HttpConnectionOptions(
//         accessTokenFactory: () => Future.value(userToken),
//       ),
//     )
//         .build();
//
//     hubConnection?.on('NotifyChangeStatusForUser', (arguments) {
//       if (arguments != null && arguments.length >= 3) {
//         try {
//           final int status = arguments[0] as int;
//           final int receivedOrderId = arguments[1] as int;
//           final Map<String, dynamic> checkData =
//           arguments[2] as Map<String, dynamic>;
//           final String receivedUserEmail = checkData['email'] as String;
//           final String userType = checkData['type'] as String;
//
//           print(
//             'SignalR Update Received (AllOrdersScreen): OrderID=$receivedOrderId, Status=$status, UserType=$userType, Email=$receivedUserEmail',
//           );
//
//           if (userType == "User" && receivedUserEmail == userEmail) {
//             context.read<TrackingCubit>().updateOrderStatus(
//               orderId: receivedOrderId,
//               newStatus: status,
//               userEmail: receivedUserEmail,
//               userType: userType,
//             );
//           } else {
//             print(
//               'SignalR (AllOrdersScreen): Update ignored. UserType/Email mismatch.',
//             );
//           }
//         } catch (e) {
//           print(
//             "Error parsing SignalR arguments (AllOrdersScreen): $e, arguments: $arguments",
//           );
//         }
//       } else {
//         print(
//           "SignalR received insufficient arguments (AllOrdersScreen): $arguments",
//         );
//       }
//     });
//
//     try {
//       await hubConnection?.start();
//       print("SignalR Connected to $hubUrl (from AllOrdersScreen)");
//       _isSignalRInitialized = true;
//     } catch (e) {
//       print(
//         "Error connecting to SignalR Hub at $hubUrl (from AllOrdersScreen): $e",
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: BlocConsumer<TrackingCubit, TrackingState>(
//         listener: (context, state) {
//           if (state is TrackingError) {
//             CustomToast.show(
//               message: "Something went wrong. Please try again later.",
//             );
//           }
//         },
//         builder: (context, state) {
//           if (state is TrackingLoading) {
//             return  Center(child: CircularProgressIndicator(
//               color: Colors.white,
//             ));
//           } else if (state is TrackingLoaded) {
//             return ListView.builder(
//               padding: const EdgeInsets.all(16.0),
//               itemCount: state.trackingData.length,
//               itemBuilder: (context, index) {
//                 final order = state.trackingData[index];
//                 return Padding(
//                   padding: const EdgeInsets.only(bottom: 16.0),
//                   child: TrackOrderWidget(
//                     orderId: order.orderId,
//                     onRatePressed: () {
//                       showDialog(
//                         context: context,
//                         builder: (context) =>
//                             RatingReviewDialog(orderId: order.orderId),
//                       );
//                     },
//                   ),
//                 );
//               },
//             );
//           } else if (state is TrackingEmpty) {
//             return  Center(
//               child: Text(
//                 "You have no orders to track.",
//                 style: TextStyle(fontSize: 16.sp),
//               ),
//             );
//           }
//           return  Center(
//             child: Text(
//               "Welcome! Loading your orders...",
//               style: TextStyle(fontSize: 16.sp),
//             ),
//           );
//         },
//       )
//
//     );
//   }
// }
