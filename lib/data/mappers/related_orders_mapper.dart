import 'package:hatley_delivery/data/model/RelatedOrdersResponse.dart';
import 'package:hatley_delivery/domain/entities/related_orders_entity.dart';

extension RelatedOrdersMapper on OrdersResponse {
  RelatedOrdersEntity toEntity() {
    return RelatedOrdersEntity(
      orderId: orderId ?? -1,
      orderTime: orderTime ?? '',
      price: price ?? 0,
      orderDescription: description ?? '',
      orderZoneFrom: orderZoneFrom ?? '',
      orderCityFrom: orderCityFrom ?? '',
      detailesAddressFrom: detailesAddressFrom ?? '',
      orderZoneTo: orderZoneTo ?? '',
      orderCityTo: orderCityTo ?? '',
      detailesAddressTo: detailesAddressTo ?? '',
    );
  }
}
