part of 'health_sync_bloc.dart';

sealed class HealthSyncEvent extends Equatable {
  const HealthSyncEvent();
}

class UserHealthSyncEvent extends HealthSyncEvent {
  final String url;
  final Map<String, dynamic> body;

  const UserHealthSyncEvent({required this.url, required this.body});

  @override
  List<Object?> get props => [url, body];
}
