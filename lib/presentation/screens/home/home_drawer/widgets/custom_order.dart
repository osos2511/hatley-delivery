import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hatley_delivery/presentation/cubit/offer_cubit/offer_cubit.dart';
import 'package:hatley_delivery/presentation/cubit/offer_cubit/offer_state.dart';
import 'package:hatley_delivery/domain/usecases/get_offer_usecase.dart';
import 'package:hatley_delivery/presentation/screens/home/home_drawer/widgets/custom_order_button.dart';
import 'package:intl/intl.dart';
import '../../../../../core/colors_manager.dart';
import '../../../../../domain/entities/related_orders_entity.dart';
import '../../../../../injection_container.dart';

class CustomOrderWidget extends StatefulWidget {
  const CustomOrderWidget({super.key, required this.order});
  final RelatedOrdersEntity order;
  @override
  State<CustomOrderWidget> createState() => _CustomOrderWidgetState();
}

class _CustomOrderWidgetState extends State<CustomOrderWidget> {
  num? offerPrice;
  num? originalPrice; // لحفظ القيمة الأصلية

  void _showOfferDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // للتحكم في الطول
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return BlocProvider<OfferCubit>(
          create: (context) =>
              OfferCubit(sl<GetOfferUsecase>())..getOffer(widget.order.orderId),
          child: Container(
            // للتحكم في الطول - ممكن تعدل القيم
            height:
                MediaQuery.of(context).size.height *
                0.22, // 40% من ارتفاع الشاشة
            padding: const EdgeInsets.all(16),
            child: BlocBuilder<OfferCubit, OfferState>(
              builder: (context, state) {
                if (state is OfferLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: ColorsManager.buttonColorApp,
                    ),
                  );
                } else if (state is GetOfferSuccess) {
                  // حفظ القيمة الأصلية أول مرة فقط
                  originalPrice ??= state.offer.price;
                  // إعادة تعيين الـ offerPrice للقيمة الأصلية كل مرة
                  offerPrice = originalPrice;
                  return StatefulBuilder(
                    builder: (context, setState) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Set Your Offer Price",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: ColorsManager.primaryColorApp,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    if (offerPrice != null && offerPrice! > 5) {
                                      offerPrice = offerPrice! - 5;
                                    }
                                  });
                                },
                                icon: const Icon(Icons.remove_circle_outline),
                              ),
                              Text(
                                "EGP ${offerPrice ?? 50}",
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    if (offerPrice != null) {
                                      offerPrice = offerPrice! + 5;
                                    }
                                  });
                                },
                                icon: const Icon(Icons.add_circle_outline),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          CustomOrderButton(
                            text: "Send Offer",
                            onPressed: () {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "Offer sent: EGP ${offerPrice ?? 50}",
                                  ),
                                ),
                              );
                            },
                            backgroundColor: ColorsManager.buttonColorApp,
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  return const Center(child: Text("No offer available"));
                }
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final parsedDateTime = DateTime.parse(widget.order.orderTime);
    final formattedDate = DateFormat('dd MMM yyyy').format(parsedDateTime);
    final formattedTime = DateFormat('hh:mm a').format(parsedDateTime);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "ID: ${widget.order.orderId}",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: ColorsManager.primaryColorApp,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "Date: $formattedDate",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "Time: $formattedTime",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Center(
              child: Image.asset(
                'assets/follow.png',
                height: 90,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text(
                  "Price: ",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade700,
                  ),
                ),
                Text(
                  "${widget.order.price} EGP",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: ColorsManager.primaryColorApp,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.location_on,
                  size: 18,
                  color: ColorsManager.primaryColorApp,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    "From: ${widget.order.orderZoneFrom}, ${widget.order.orderCityFrom}, ${widget.order.detailesAddressFrom}",
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade800),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.flag,
                  size: 18,
                  color: ColorsManager.primaryColorApp,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    "To: ${widget.order.orderZoneTo}, ${widget.order.orderCityTo}, ${widget.order.detailesAddressTo}",
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade800),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Center(
              child: CustomOrderButton(
                backgroundColor: ColorsManager.buttonColorApp,
                onPressed: () {
                  _showOfferDialog(context);
                },
                text: "Make Offer",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
