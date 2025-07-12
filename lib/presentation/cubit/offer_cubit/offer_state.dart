import 'package:hatley_delivery/domain/entities/offer_entity.dart';

abstract class OfferState {}

class OfferInitial extends OfferState {}

class OfferLoading extends OfferState {}

class GetOfferSuccess extends OfferState {
  final OfferEntity offer;
  GetOfferSuccess(this.offer);
}

class OfferFailure extends OfferState {
  final String error;
  OfferFailure(this.error);
}
