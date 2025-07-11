// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:hatley/core/colors_manager.dart';
// import 'package:hatley/core/reusable_order_form.dart';
// import 'package:hatley/domain/entities/order_entity.dart';
// import 'package:hatley/injection_container.dart';
// import 'package:hatley/presentation/cubit/edit_order_cubit/edit_order_cubit.dart';
// import 'package:hatley/presentation/cubit/governorate_cubit/governorate_cubit.dart';
// import 'package:hatley/presentation/cubit/order_cubit/order_state.dart';
// import 'package:hatley/presentation/cubit/zone_cubit/zone_cubit.dart';
// import 'package:hatley/presentation/screens/auth/widgets/custom_toast.dart';
// import '../../../../cubit/make_orders_cubit/make_orders_cubit.dart';
//
// void showEditOrderDialog(
//   BuildContext context,
//   MakeOrderCubit makeOrderCubit,
//   OrderEntity order,
// ) {
//   makeOrderCubit.loadOrderForEdit(order);
//
//   showDialog(
//     context: context,
//     builder: (context) {
//       return MultiBlocProvider(
//         providers: [
//           BlocProvider.value(value: makeOrderCubit),
//           BlocProvider(create: (_) => sl<EditOrderCubit>()),
//           BlocProvider(
//             create: (_) => sl<GovernorateCubit>()..fetchGovernorates(),
//           ),
//           BlocProvider(create: (_) => sl<ZoneCubit>()),
//         ],
//         child: BlocConsumer<EditOrderCubit, OrderState>(
//           listener: (context, state) {
//             if (state is OrderSuccess) {
//               Navigator.of(context).pop();
//               CustomToast.show(message: 'Edit Order has Done');
//             } else if (state is OrderFailure) {
//               print("خطأ أثناء التعديل: ${state.error}");
//               ScaffoldMessenger.of(
//                 context,
//               ).showSnackBar(SnackBar(content: Text(state.error)));
//             }
//           },
//           builder: (context, state) {
//             return AlertDialog(
//               backgroundColor: ColorsManager.primaryColorApp,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               contentPadding: const EdgeInsets.all(20),
//               content: SingleChildScrollView(
//                 child: ReusableOrderForm(
//                   isEdit: true,
//                   orderId: order.orderId,
//                   submitButtonText: 'Save Changes',
//                   onSubmit: () {
//                     FocusScope.of(context).unfocus();
//                     final editCubit = context.read<EditOrderCubit>();
//                     final makeOrderCubit = context.read<MakeOrderCubit>();
//
//                     final fromAddress =
//                         makeOrderCubit.fromAddressController.text.trim();
//                     final toAddress =
//                         makeOrderCubit.toAddressController.text.trim();
//                     final priceText =
//                         makeOrderCubit.priceController.text.trim();
//                     final description =
//                         makeOrderCubit.detailsController.text.trim();
//
//                     if (description.isEmpty ||
//                         fromAddress.isEmpty ||
//                         toAddress.isEmpty ||
//                         priceText.isEmpty ||
//                         makeOrderCubit.state.selectedGovernorateFrom == null ||
//                         makeOrderCubit.state.selectedStateFrom == null ||
//                         makeOrderCubit.state.selectedCityFrom == null ||
//                         makeOrderCubit.state.selectedGovernorateTo == null ||
//                         makeOrderCubit.state.selectedStateTo == null ||
//                         makeOrderCubit.state.selectedCityTo == null ||
//                         makeOrderCubit.state.selectedDate == null ||
//                         makeOrderCubit.state.selectedTime == null) {
//
//                       CustomToast.show(message: 'Please Fill all Required Fields');
//
//                       return;
//                     }
//
//                     final price = num.tryParse(priceText);
//                     if (price == null || price <= 0) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                           content: Text('يرجى إدخال سعر صحيح'),
//                           backgroundColor: Colors.red,
//                         ),
//                       );
//                       return;
//                     }
//
//                     editCubit.editOrder(
//                       orderId: order.orderId,
//                       description: description,
//                       orderGovernorateFrom:
//                           makeOrderCubit.state.selectedGovernorateFrom!,
//                       orderZoneFrom: makeOrderCubit.state.selectedStateFrom!,
//                       orderCityFrom: makeOrderCubit.state.selectedCityFrom!,
//                       detailesAddressFrom: fromAddress,
//                       orderGovernorateTo:
//                           makeOrderCubit.state.selectedGovernorateTo!,
//                       orderZoneTo: makeOrderCubit.state.selectedStateTo!,
//                       orderCityTo: makeOrderCubit.state.selectedCityTo!,
//                       detailesAddressTo: toAddress,
//                       orderTime:
//                           makeOrderCubit.combineDateAndTime(
//                             makeOrderCubit.state.selectedDate,
//                             makeOrderCubit.state.selectedTime,
//                           ) ??
//                           DateTime.now(),
//                       price: price,
//                     );
//                   },
//                 ),
//               ),
//             );
//           },
//         ),
//       );
//     },
//   );
// }
