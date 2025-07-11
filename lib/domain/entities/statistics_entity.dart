class StatisticsEntity {
  final int totalOrders;
  final int completeOrders;
  final int incompleteOrders;
  final int pending;
  final int ordersLast30Days;
  final double rate;

  StatisticsEntity({
    required this.totalOrders,
    required this.completeOrders,
    required this.incompleteOrders,
    required this.pending,
    required this.ordersLast30Days,
    required this.rate,
  });
}
