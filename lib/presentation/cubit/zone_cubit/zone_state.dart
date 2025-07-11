import '../../../domain/entities/zone_entity.dart';

abstract class ZoneState{}
class ZoneInitial extends ZoneState {}


class ZonesLoading extends ZoneState {}


class ZonesLoaded extends ZoneState {
  final List<ZoneEntity> zones;
  ZonesLoaded(this.zones);
}

class ZoneError extends ZoneState {
  final String message;
  ZoneError(this.message);
}