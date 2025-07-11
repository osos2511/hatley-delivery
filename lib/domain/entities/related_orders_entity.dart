class RelatedOrdersEntity {
  final num orderId;
  final String orderTime;
  final num price;
  final String? photo;
  final String orderDescription;
  final String orderZoneFrom;
  final String orderCityFrom;
  final String detailesAddressFrom;
  final String orderZoneTo;
  final String orderCityTo;
  final String detailesAddressTo;

  RelatedOrdersEntity({
    required this.orderId,
    required this.orderTime,
    required this.price,
    this.photo,
    required this.orderDescription,
    required this.orderZoneFrom,
    required this.orderCityFrom,
    required this.detailesAddressFrom,
    required this.orderZoneTo,
    required this.orderCityTo,
    required this.detailesAddressTo,
  });
}
