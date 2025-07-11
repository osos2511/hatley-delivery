class StatisticsResponse {
  final int totalOrders;
  final int completeOrders;
  final int incompleteOrders;
  final int pending;
  final int ordersLast30Days;
  final double rate;

  StatisticsResponse({
    required this.totalOrders,
    required this.completeOrders,
    required this.incompleteOrders,
    required this.pending,
    required this.ordersLast30Days,
    required this.rate,
  });

  factory StatisticsResponse.fromJson(Map<String, dynamic> json) {
    return StatisticsResponse(
      totalOrders: json['total_orders'] ?? 0,
      completeOrders: json['complete_orders'] ?? 0,
      incompleteOrders: json['incomplete_orders'] ?? 0,
      pending: json['pending'] ?? 0,
      ordersLast30Days: json['orders_last_30_days'] ?? 0,
      rate: (json['rate'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_orders': totalOrders,
      'complete_orders': completeOrders,
      'incomplete_orders': incompleteOrders,
      'pending': pending,
      'orders_last_30_days': ordersLast30Days,
      'rate': rate,
    };
  }
}
