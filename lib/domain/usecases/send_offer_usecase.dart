import 'package:dartz/dartz.dart';
import 'package:hatley_delivery/domain/entities/offer_send_entity.dart';
import 'package:hatley_delivery/domain/repo/offer_repo.dart';
import '../../core/error/failure.dart';

class SendOfferUseCase {
  OfferRepo offerRepo;
  SendOfferUseCase(this.offerRepo);

  Future<Either<Failure, OfferSendEntity>> call({
    required int orderId,
    required String email,
    required num value,
  }) {
    return offerRepo.sendOffer(orderId: orderId, email: email, value: value);
  }
}
