import 'package:hatley_delivery/data/model/orders_response.dart';
import 'package:hatley_delivery/domain/entities/previous_order_entity.dart';

extension PreviousOrdersMapper on OrdersResponse {
  PreviosOrdersEntity toPreviousOrdersEntity() {
    return PreviosOrdersEntity(
      orderId: orderId ?? 0,
      orderRate: orderRate,
      description: description ?? '',
      orderCityFrom: orderCityFrom ?? '',
      orderCityTo: orderCityTo ?? '',
      created: created ?? '',
      price: price ?? 0,
      status: status ?? 0,
      userName: name ?? '',
    );
  }
}
