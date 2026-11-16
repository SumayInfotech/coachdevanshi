part of 'health_sync_bloc.dart';

sealed class HealthSyncState extends Equatable {
  const HealthSyncState();
}

class HealthSyncInitial extends HealthSyncState {
  @override
  List<Object?> get props => [];
}

class HealthSyncLoading extends HealthSyncState {
  @override
  List<Object?> get props => [];
}

class HealthSyncSuccess extends HealthSyncState {
  final CommonModel model;

  const HealthSyncSuccess({required this.model});

  @override
  List<Object?> get props => [model];
}

class HealthSyncFailed extends HealthSyncState {
  final String message;

  const HealthSyncFailed({required this.message});

  @override
  List<Object?> get props => [message];
}
