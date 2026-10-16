part of 'location_bloc.dart';

sealed class LocationState extends Equatable {
  const LocationState();
}

final class LocationInitial extends LocationState {
  @override
  List<Object> get props => [];
}

final class LocationLoading extends LocationState {
  @override
  List<Object> get props => [];
}

final class LocationSuccess extends LocationState {
  final LocationModel model;

  const new({required this.model});

  @override
  List<Object> get props => [];
}

final class LocationFailed extends LocationState {
  final String message;

  const new({required this.message});

  @override
  List<Object> get props => [];
}
