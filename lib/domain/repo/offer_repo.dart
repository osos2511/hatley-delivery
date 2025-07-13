import 'package:dartz/dartz.dart';
import 'package:hatley_delivery/core/error/failure.dart';
import 'package:hatley_delivery/domain/entities/offer_entity.dart';
import 'package:hatley_delivery/domain/entities/offer_send_entity.dart';

abstract class OfferRepo {
  Future<Either<Failure, OfferEntity>> getOffer(num orderId);
  Future<Either<Failure, OfferSendEntity>> sendOffer({
    required int orderId,
    required String email,
    required num value,
  });
}
