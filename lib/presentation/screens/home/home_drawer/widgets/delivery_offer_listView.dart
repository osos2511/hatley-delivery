// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:hatley/core/colors_manager.dart';
// import 'package:hatley/presentation/cubit/offer_cubit/offer_cubit.dart';
// import 'package:hatley/presentation/cubit/offer_cubit/offer_state.dart';
// import 'package:signalr_netcore/signalr_client.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:hatley/core/local/token_storage.dart';
// import '../../../../../core/routes_manager.dart';
// import '../../../../cubit/navigation_cubit.dart';
// import 'custom_order_button.dart';
//
// class DeliveryOffersWidget extends StatefulWidget {
//   final int? orderId;
//   const DeliveryOffersWidget({super.key, this.orderId});
//
//   @override
//   State<DeliveryOffersWidget> createState() => _DeliveryOffersWidgetState();
// }
//
// class _DeliveryOffersWidgetState extends State<DeliveryOffersWidget> {
//   final List<Map<String, dynamic>> _offers = [];
//   late final HubConnection _hubConnection;
//   static const String _serverUrl =
//       "https://hatley.runasp.net/NotifyNewOfferForUser";
//   String? _userEmail;
//   late final TokenStorage _tokenStorage;
//
//   Map<String, dynamic>? _pendingOfferToDelete;
//   int? _pendingOfferIndexToDelete;
//
//   @override
//   void initState() {
//     super.initState();
//     _initialize();
//   }
//
//   Future<void> _initialize() async {
//     final prefs = await SharedPreferences.getInstance();
//     _tokenStorage = TokenStorageImpl(prefs);
//     _userEmail = await _tokenStorage.getEmail();
//     await _startSignalRConnection();
//   }
//
//   Future<void> _startSignalRConnection() async {
//     _hubConnection = HubConnectionBuilder()
//         .withUrl(
//       _serverUrl,
//       options: HttpConnectionOptions(
//         transport: HttpTransportType.WebSockets,
//       ),
//     )
//         .withAutomaticReconnect()
//         .build();
//
//     _hubConnection.onclose(({Exception? error}) {});
//     _hubConnection.onreconnecting(({Exception? error}) {});
//
//     try {
//       await _hubConnection.start();
//       _registerSignalRListeners();
//     } catch (e) {
//       print("Error connecting to SignalR for offers: $e");
//     }
//   }
//
//   void _registerSignalRListeners() {
//     _hubConnection.on("NotifyNewOfferForUser", (arguments) {
//       if (arguments != null && arguments.length == 2) {
//         final offerData = arguments[0] as Map<dynamic, dynamic>;
//         final checkData = arguments[1] as Map<dynamic, dynamic>;
//
//         final checkEmail = checkData["email"];
//         final checkType = checkData["type"];
//
//         if (checkEmail == _userEmail && checkType == "User") {
//           final orderId = offerData["order_id"] is int
//               ? offerData["order_id"]
//               : int.tryParse(offerData["order_id"].toString());
//           if (orderId == null) return;
//
//           final newOffer = {
//             "order_id": orderId,
//             "name": offerData["delivery_name"],
//             "price": offerData["offer_value"].toString(),
//             "rating": double.tryParse(offerData["delivery_avg_rate"].toString()) ?? 0.0,
//             "image": offerData["delivery_photo"] ?? "",
//             "delivery_email": offerData["delivery_email"],
//             "offer_value": offerData["offer_value"],
//           };
//
//           if (widget.orderId == null || newOffer["order_id"] == widget.orderId) {
//             setState(() {
//               _offers.add(newOffer);
//             });
//             Future.delayed(const Duration(seconds: 10), () {
//               if (mounted && _offers.contains(newOffer)) {
//                 setState(() {
//                   _offers.remove(newOffer);
//                 });
//               }
//             });
//           }
//         }
//       }
//     });
//   }
//
//   void _handleOfferResponse(int index, bool accepted) {
//     final offer = _offers[index];
//     final orderId = offer["order_id"] as int?;
//     final deliveryEmail = offer["delivery_email"] as String?;
//     final priceOfOffer = int.tryParse(offer["offer_value"].toString());
//
//     _pendingOfferToDelete = offer;
//     _pendingOfferIndexToDelete = index;
//
//     if (orderId == null ||
//         deliveryEmail == null ||
//         (accepted && priceOfOffer == null)) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Missing offer details.'),
//           backgroundColor: Colors.orange,
//         ),
//       );
//       _pendingOfferToDelete = null;
//       _pendingOfferIndexToDelete = null;
//       return;
//     }
//
//     if (accepted) {
//       context.read<OfferCubit>().acceptOffer(
//         orderId,
//         priceOfOffer!,
//         deliveryEmail,
//       );
//     } else {
//       context.read<OfferCubit>().declineOffer(
//         orderId,
//         priceOfOffer ?? 0,
//         deliveryEmail,
//       );
//     }
//   }
//
//   @override
//   void dispose() {
//     _hubConnection.stop();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (_offers.isEmpty) {
//       return const Center(
//         child: Text("No offers received yet for this order."),
//       );
//     }
//
//     return BlocListener<OfferCubit, OfferState>(
//       listener: (context, state) {
//         if (state is OfferAcceptedSuccess) {
//           final int acceptedOrderId = state.orderId;
//           setState(() {
//             _offers.removeWhere((offer) => offer["order_id"] == acceptedOrderId);
//           });
//
//           context.read<NavigationCubit>().changePage(1);
//           Navigator.pushNamedAndRemoveUntil(
//             context,
//             RoutesManager.homeRoute,
//                 (route) => false,
//           );
//
//           _pendingOfferToDelete = null;
//           _pendingOfferIndexToDelete = null;
//         } else if (state is OfferDeclinedSuccess) {
//           if (_pendingOfferToDelete != null && _pendingOfferIndexToDelete != null) {
//             setState(() {
//               _offers.removeAt(_pendingOfferIndexToDelete!);
//             });
//           }
//           _pendingOfferToDelete = null;
//           _pendingOfferIndexToDelete = null;
//         } else if (state is OfferFailure) {
//           _pendingOfferToDelete = null;
//           _pendingOfferIndexToDelete = null;
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text('Failed to process offer: ${state.errorMessage}'),
//               backgroundColor: Colors.red,
//             ),
//           );
//         }
//       },
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Delivery Offers:',
//             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
//           ),
//           SizedBox(height: 12.h),
//           SizedBox(
//             height: 190.h,
//             child: ListView.separated(
//               scrollDirection: Axis.horizontal,
//               itemCount: _offers.length,
//               separatorBuilder: (_, __) => SizedBox(width: 12.w),
//               itemBuilder: (context, index) {
//                 final offer = _offers[index];
//                 final imageUrl = offer["image"] as String;
//
//                 return SizedBox(
//                   width: 250.w,
//                   child: Card(
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12.r),
//                       side: BorderSide(color: ColorsManager.primaryColorApp),
//                     ),
//                     elevation: 4,
//                     child: Padding(
//                       padding: REdgeInsets.all(16),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Row(
//                             children: [
//                               CircleAvatar(
//                                 radius: 28,
//                                 backgroundImage: imageUrl.isNotEmpty
//                                     ? NetworkImage(imageUrl)
//                                     : const AssetImage("assets/images/default_user.png")
//                                 as ImageProvider,
//                               ),
//                               SizedBox(width: 12.w),
//                               Expanded(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       offer["name"],
//                                       style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 18.sp,
//                                       ),
//                                       overflow: TextOverflow.ellipsis,
//                                     ),
//                                     SizedBox(height: 6.h),
//                                     Row(
//                                       children: [
//                                         Icon(
//                                           Icons.star,
//                                           color: Colors.amber[700],
//                                           size: 18.sp,
//                                         ),
//                                         SizedBox(width: 4.w),
//                                         Text(
//                                           offer["rating"].toString(),
//                                           style: TextStyle(fontSize: 14.sp),
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                           Text(
//                             "Offer Price: ${offer["price"]} EGP",
//                             style: TextStyle(
//                               fontWeight: FontWeight.w600,
//                               fontSize: 16.sp,
//                               color: Colors.green,
//                             ),
//                           ),
//                           Row(
//                             children: [
//                               Expanded(
//                                 child: CustomOrderButton(
//                                   onPressed: () => _handleOfferResponse(index, true),
//                                   backgroundColor: ColorsManager.primaryColorApp,
//                                   text: "Accept",
//                                 ),
//                               ),
//                               SizedBox(width: 8.w),
//                               Expanded(
//                                 child: CustomOrderButton(
//                                   onPressed: () => _handleOfferResponse(index, false),
//                                   backgroundColor: ColorsManager.buttonColorApp,
//                                   text: "Decline",
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 );
//
//               },
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }