import '../model/offer_send_response.dart';
import '../../domain/entities/offer_send_entity.dart';

extension OfferSendMapper on OfferSendResponse {
  OfferSendEntity toEntity() {
    return OfferSendEntity(
      offerId: offerId ?? '',
      orderId: orderId ?? 0,
      deliveryEmail: deliveryEmail ?? '',
      deliveryName: deliveryName ?? '',
      deliveryPhoto: deliveryPhoto ?? '',
      offerValue: offerValue ?? 0,
      deliveryAvgRate: deliveryAvgRate ?? 0,
      deliveryCountRate: deliveryCountRate ?? 0,
    );
  }
}
