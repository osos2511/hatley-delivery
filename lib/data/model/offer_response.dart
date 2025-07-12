class OfferResponse {
  OfferResponse({
    this.orderId,
    this.userName,
    this.userPhoto,
    this.description,
    this.from,
    this.to,
    this.price,
    this.deliveryEmail,
  });

  OfferResponse.fromJson(dynamic json) {
    orderId = json['order_id'];
    userName = json['user_name'];
    userPhoto = json['user_photo'];
    description = json['description'];
    from = json['from'];
    to = json['to'];
    price = json['price'];
    deliveryEmail = json['delivery_email'];
  }

  num? orderId;
  String? userName;
  String? userPhoto;
  String? description;
  String? from;
  String? to;
  num? price;
  String? deliveryEmail;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['order_id'] = orderId;
    map['user_name'] = userName;
    map['user_photo'] = userPhoto;
    map['description'] = description;
    map['from'] = from;
    map['to'] = to;
    map['price'] = price;
    map['delivery_email'] = deliveryEmail;
    return map;
  }
}
