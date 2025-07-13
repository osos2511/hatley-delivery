class OfferSendResponse {
  String? offerId;
  int? orderId;
  String? deliveryEmail;
  String? deliveryName;
  String? deliveryPhoto;
  num? offerValue;
  num? deliveryAvgRate;
  num? deliveryCountRate;

  OfferSendResponse({
    this.offerId,
    this.orderId,
    this.deliveryEmail,
    this.deliveryName,
    this.deliveryPhoto,
    this.offerValue,
    this.deliveryAvgRate,
    this.deliveryCountRate,
  });

  OfferSendResponse.fromJson(dynamic json) {
    offerId = json['offer_id'];
    orderId = json['order_id'];
    deliveryEmail = json['delivery_email'];
    deliveryName = json['delivery_name'];
    deliveryPhoto = json['delivery_photo'];
    offerValue = json['offer_value'];
    deliveryAvgRate = json['delivery_avg_rate'];
    deliveryCountRate = json['delivery_count_rate'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['offer_id'] = offerId;
    map['order_id'] = orderId;
    map['delivery_email'] = deliveryEmail;
    map['delivery_name'] = deliveryName;
    map['delivery_photo'] = deliveryPhoto;
    map['offer_value'] = offerValue;
    map['delivery_avg_rate'] = deliveryAvgRate;
    map['delivery_count_rate'] = deliveryCountRate;
    return map;
  }
}
