class RelatedOrdersResponse {
  RelatedOrdersResponse({
      this.orderId, 
      this.orderRate, 
      this.description, 
      this.orderGovernorateFrom, 
      this.orderZoneFrom, 
      this.orderCityFrom, 
      this.detailesAddressFrom, 
      this.orderGovernorateTo, 
      this.orderZoneTo, 
      this.orderCityTo, 
      this.detailesAddressTo, 
      this.created, 
      this.orderTime, 
      this.price, 
      this.status, 
      this.userID, 
      this.deliveryID, 
      this.name, 
      this.photo, 
      this.ordersCount, 
      this.avgRate, 
      this.countRate,});

  RelatedOrdersResponse.fromJson(dynamic json) {
    orderId = json['order_id'];
    orderRate = json['order_rate'];
    description = json['description'];
    orderGovernorateFrom = json['order_governorate_from'];
    orderZoneFrom = json['order_zone_from'];
    orderCityFrom = json['order_city_from'];
    detailesAddressFrom = json['detailes_address_from'];
    orderGovernorateTo = json['order_governorate_to'];
    orderZoneTo = json['order_zone_to'];
    orderCityTo = json['order_city_to'];
    detailesAddressTo = json['detailes_address_to'];
    created = json['created'];
    orderTime = json['order_time'];
    price = json['price'];
    status = json['status'];
    userID = json['user_ID'];
    deliveryID = json['delivery_ID'];
    name = json['name'];
    photo = json['photo'];
    ordersCount = json['orders_count'];
    avgRate = json['avg_rate'];
    countRate = json['count_rate'];
  }
  num? orderId;
  dynamic orderRate;
  String? description;
  String? orderGovernorateFrom;
  String? orderZoneFrom;
  String? orderCityFrom;
  String? detailesAddressFrom;
  String? orderGovernorateTo;
  String? orderZoneTo;
  String? orderCityTo;
  String? detailesAddressTo;
  String? created;
  String? orderTime;
  num? price;
  num? status;
  num? userID;
  dynamic deliveryID;
  String? name;
  String? photo;
  num? ordersCount;
  dynamic avgRate;
  dynamic countRate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['order_id'] = orderId;
    map['order_rate'] = orderRate;
    map['description'] = description;
    map['order_governorate_from'] = orderGovernorateFrom;
    map['order_zone_from'] = orderZoneFrom;
    map['order_city_from'] = orderCityFrom;
    map['detailes_address_from'] = detailesAddressFrom;
    map['order_governorate_to'] = orderGovernorateTo;
    map['order_zone_to'] = orderZoneTo;
    map['order_city_to'] = orderCityTo;
    map['detailes_address_to'] = detailesAddressTo;
    map['created'] = created;
    map['order_time'] = orderTime;
    map['price'] = price;
    map['status'] = status;
    map['user_ID'] = userID;
    map['delivery_ID'] = deliveryID;
    map['name'] = name;
    map['photo'] = photo;
    map['orders_count'] = ordersCount;
    map['avg_rate'] = avgRate;
    map['count_rate'] = countRate;
    return map;
  }

}