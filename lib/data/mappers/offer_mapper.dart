import 'package:hatley_delivery/data/model/offer_response.dart';
import 'package:hatley_delivery/domain/entities/offer_entity.dart';

extension OfferMapper on OfferResponse {
  OfferEntity toEntity() {
    return OfferEntity(price: price ?? 0);
  }
}
