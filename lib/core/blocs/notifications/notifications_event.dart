part of 'notifications_bloc.dart';

sealed class NotificationsEvent extends Equatable {
  const NotificationsEvent();
}

class FetchNotificationsEvent extends NotificationsEvent {
  final String url;

  const FetchNotificationsEvent({required this.url});

  @override
  List<Object?> get props => [url];
}
