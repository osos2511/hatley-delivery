import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hatley_delivery/core/colors_manager.dart';
import 'package:hatley_delivery/domain/entities/previous_order_entity.dart';
import 'package:hatley_delivery/injection_container.dart';
import 'package:hatley_delivery/presentation/cubit/deliveries_cubit/deliveries_cubit.dart';
import 'package:hatley_delivery/presentation/cubit/deliveries_cubit/previous_orders_state.dart';
import 'package:intl/intl.dart';

const kPrimaryColor = ColorsManager.primaryColorApp;

class PreviousOrders extends StatelessWidget {
  const PreviousOrders({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<PreviousOrdersCubit>()..getAllOrders(),
      child: Scaffold(
        body: BlocBuilder<PreviousOrdersCubit, PreviousOrdersState>(
          builder: (context, state) {
            if (state is PreviousOrdersLoading) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            }
            if (state is PreviousOrdersError) {
              return Center(
                child: Text(
                  'Error: ${state.message}',
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
              );
            }
            if (state is PreviousOrdersLoaded) {
              final orders = state.orders;
              return ListView.builder(
                padding: EdgeInsets.all(16.0),
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  return DeliveriesListItem(order: order);
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class DeliveriesListItem extends StatelessWidget {
  final PreviosOrdersEntity order;

  DeliveriesListItem({required this.order});

  @override
  Widget build(BuildContext context) {
    String formattedDateTime = '';
    try {
      final date = DateTime.parse(order.created);
      formattedDateTime = DateFormat('dd/MM/yyyy - hh:mm a').format(date);
    } catch (_) {
      formattedDateTime = order.created;
    }
    return Card(
      margin: EdgeInsets.only(bottom: 16.0),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(color: kPrimaryColor.withOpacity(0.2), width: 1.0),
      ),
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Driver Name + Rating
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'User: ${order.userName}',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: kPrimaryColor,
                  ),
                ),
                Row(
                  children: List.generate(5, (index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 1),
                      child: Icon(
                        Icons.star,
                        color:
                            (order.orderRate != null &&
                                order.orderRate! > index)
                            ? Colors.amber
                            : Colors.grey[400],
                        size: 18,
                      ),
                    );
                  }),
                ),
              ],
            ),

            SizedBox(height: 8),

            // Order ID + Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order ID: ${order.orderId}',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: kPrimaryColor,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: kPrimaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Completed',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: kPrimaryColor,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 8),

            // Date
            Text(
              formattedDateTime,
              style: TextStyle(
                fontSize: 14.sp,
                color: kPrimaryColor.withOpacity(0.8),
              ),
            ),

            Divider(
              height: 20,
              thickness: 0.5,
              color: kPrimaryColor.withOpacity(0.2),
            ),

            // From / To
            Text(
              'From: ${order.orderCityFrom}',
              style: TextStyle(
                fontSize: 14.sp,
                color: kPrimaryColor.withOpacity(0.8),
              ),
            ),

            SizedBox(height: 4),

            Text(
              'To: ${order.orderCityTo}',
              style: TextStyle(
                fontSize: 14.sp,
                color: kPrimaryColor.withOpacity(0.8),
              ),
            ),

            SizedBox(height: 8),

            // Price
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                '${order.price.toInt()} EGP',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: kPrimaryColor,
                ),
              ),
            ),

            SizedBox(height: 12),

            // Description
            Text(
              order.description,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
