class OfferSendEntity {
  final String offerId;
  final int orderId;
  final String deliveryEmail;
  final String deliveryName;
  final String deliveryPhoto;
  final num offerValue;
  final num deliveryAvgRate;
  final num deliveryCountRate;

  OfferSendEntity({
    required this.offerId,
    required this.orderId,
    required this.deliveryEmail,
    required this.deliveryName,
    required this.deliveryPhoto,
    required this.offerValue,
    required this.deliveryAvgRate,
    required this.deliveryCountRate,
  });
}
