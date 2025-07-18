import '../../../data/model/traking_response.dart';

abstract class TrackingState {}

class TrackingInitial extends TrackingState {}

class TrackingLoading extends TrackingState {}

class TrackingLoaded extends TrackingState {
  final List<TrakingResponse> trackingData;
  TrackingLoaded({required this.trackingData});
}

class TrackingEmpty extends TrackingState {} 

class TrackingError extends TrackingState {
  final String message;
  TrackingError({required this.message});
}
