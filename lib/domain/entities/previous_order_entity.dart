class PreviosOrdersEntity {
  final num orderId;
  final int? orderRate;
  final String description;
  final String orderCityFrom;
  final String orderCityTo;
  final String created;
  final num price;
  final num status;
  final String userName;

  PreviosOrdersEntity({
    required this.orderId,
    required this.orderRate,
    required this.description,
    required this.orderCityFrom,
    required this.orderCityTo,
    required this.created,
    required this.price,
    required this.status,
    required this.userName,
  });
}
