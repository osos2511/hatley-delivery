import 'package:flutter/material.dart';
import 'package:hatley_delivery/core/colors_manager.dart';

enum OrderStatus {
  pending, // -1
  orderProcessed, // 0
  orderCompleted, // 1
  orderInRoute, // 2
  orderArrived, // 3
}

OrderStatus getOrderStatusEnum(int statusValue) {
  switch (statusValue) {
    case -1:
      return OrderStatus.pending;
    case 0:
      return OrderStatus.orderProcessed;
    case 1:
      return OrderStatus.orderCompleted;
    case 2:
      return OrderStatus.orderInRoute;
    case 3:
      return OrderStatus.orderArrived;
    default:
      return OrderStatus.pending; // fallback
  }
}

String getStatusDisplayText(OrderStatus status) {
  switch (status) {
    case OrderStatus.pending:
      return 'Pending';
    case OrderStatus.orderProcessed:
      return 'Order Processed';
    case OrderStatus.orderCompleted:
      return 'Order Completed';
    case OrderStatus.orderInRoute:
      return 'Order in Route';
    case OrderStatus.orderArrived:
      return 'Order Arrived';
  }
}

final List<String> uiTrackingSteps = const [
  'Order Processed', // index 0
  'Order Completed', // index 1
  'Order in Route', // index 2
  'Order Arrived', // index 3
];

int mapStatusToUiStepIndex(int apiStatus) {
  switch (apiStatus) {
    case 0:
      return 0; // Order Processed
    case 1:
      return 1; // Order Completed
    case 2:
      return 2; // Order in Route
    case 3:
      return 3; // Order Arrived
    default:
      return -1; // Default fallback
  }
}

Color getStatusColor(OrderStatus status) {
  switch (status) {
    case OrderStatus.orderArrived:
      return Colors.green;
    case OrderStatus.pending:
      return Colors.orange;
    default:
      return ColorsManager.primaryColorApp; // باقي الحالات
  }
}
