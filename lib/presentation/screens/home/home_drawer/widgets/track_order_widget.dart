import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:collection/collection.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hatley_delivery/core/colors_manager.dart';
import 'package:hatley_delivery/data/model/traking_response.dart';
import 'package:hatley_delivery/presentation/cubit/tracking_cubit/tracking_state.dart';
import '../../../../cubit/tracking_cubit/tracking_cubit.dart';
import '../../helper/tracking_order_helper.dart';
import 'confirm_action_dialog.dart';

class TrackOrderWidget extends StatefulWidget {
  final int? orderId;
  final VoidCallback? onRatePressed;
  const TrackOrderWidget({super.key, this.orderId, this.onRatePressed});
  @override
  State<TrackOrderWidget> createState() => _TrackOrderWidgetState();
}

class _TrackOrderWidgetState extends State<TrackOrderWidget> {
  @override
  void initState() {
    super.initState();
    print("TrackOrderWidget initialized with orderId: ${widget.orderId}");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TrackingCubit, TrackingState>(
      builder: (context, state) {
        if (state is TrackingLoaded) {
          final TrakingResponse? relevantOrder = state.trackingData
              .firstWhereOrNull((order) => order.orderId == widget.orderId);
          if (relevantOrder == null) {
            return Center(
              child: Text(
                "Order ID ${widget.orderId ?? 'undefined'} data not found.",
              ),
            );
          }

          final int currentStepIndex = mapStatusToUiStepIndex(
            relevantOrder.status,
          );
          final OrderStatus currentOrderStatusEnum = getOrderStatusEnum(
            relevantOrder.status,
          );

          return Card(
            margin: EdgeInsets.zero,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(child: Image.asset('assets/follow.png', height: 100)),
                  const SizedBox(height: 16),
                  Text(
                    'Order ID: ${relevantOrder.orderId}',
                    style: TextStyle(
                      color: Colors.green[700],
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Date: ${relevantOrder.orderTime.toLocal().toString().split('.')[0]}',
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'From: ${relevantOrder.zoneFrom}, ${relevantOrder.cityFrom}, ${relevantOrder.detailesAddressFrom}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    'To: ${relevantOrder.zoneTo}, ${relevantOrder.cityTo}, ${relevantOrder.detailesAddressTo}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      getStatusDisplayText(currentOrderStatusEnum),
                      style: TextStyle(
                        color: getStatusColor(currentOrderStatusEnum),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 100,
                    child: Row(
                      children: List.generate(uiTrackingSteps.length, (
                        stepIdx,
                      ) {
                        final bool isActive =
                            currentStepIndex >= 0 &&
                            stepIdx <= currentStepIndex;
                        final bool isLastStep =
                            stepIdx == uiTrackingSteps.length - 1;

                        return Expanded(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  if (stepIdx != 0)
                                    Expanded(
                                      child: Container(
                                        height: 3,
                                        color: (stepIdx <= currentStepIndex)
                                            ? ColorsManager.primaryColorApp
                                            : Colors.grey,
                                      ),
                                    ),
                                  Container(
                                    width: 30.w,
                                    height: 30.h,
                                    decoration: BoxDecoration(
                                      color: isActive
                                          ? ColorsManager.primaryColorApp
                                          : Colors.grey,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      isActive
                                          ? Icons.check
                                          : Icons.circle_outlined,
                                      size: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                  if (!isLastStep)
                                    Expanded(
                                      child: Container(
                                        height: 3.h,
                                        color: (stepIdx < currentStepIndex)
                                            ? ColorsManager.primaryColorApp
                                            : Colors.grey,
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                uiTrackingSteps[stepIdx],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: isActive
                                      ? Colors.green[900]
                                      : Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: Column(
                      children: [
                        // حذف زر Rate
                        // const SizedBox(height: 12),
                        Builder(
                          builder: (context) {
                            String buttonText;
                            bool isEnabled = true;
                            if (relevantOrder.status == -1) {
                              buttonText = 'Start';
                            } else if (relevantOrder.status == 0 ||
                                relevantOrder.status == 1) {
                              buttonText = 'Next';
                            } else if (relevantOrder.status == 2) {
                              buttonText = 'End';
                            } else {
                              buttonText = 'Reviews';
                            }
                            return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ColorsManager.buttonColorApp,
                                foregroundColor: Colors.white,
                                minimumSize: Size(50, 40),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () async {
                                final confirmed = await showConfirmActionDialog(
                                  context: context,
                                  title: 'Are you sure?',
                                  message:
                                      'Do you want to proceed with this action?',
                                  confirmText: 'Yes',
                                  cancelText: 'No',
                                );
                                if (confirmed == true) {
                                  context
                                      .read<TrackingCubit>()
                                      .changeOrderStatusOnServer(
                                        orderId: relevantOrder.orderId,
                                      );
                                }
                              },

                              child: Text(buttonText),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
