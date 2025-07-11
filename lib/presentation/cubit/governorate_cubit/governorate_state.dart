import '../../../domain/entities/governorate_entity.dart';

abstract class GovernorateState {}

class GovernorateInitial extends GovernorateState {}

class GovernorateLoading extends GovernorateState {}

class GovernorateLoaded extends GovernorateState{
  final List<GovernorateEntity> governorates;
  GovernorateLoaded(this.governorates);
}


class GovernorateError extends GovernorateState {
  final String message;
  GovernorateError(this.message);
}