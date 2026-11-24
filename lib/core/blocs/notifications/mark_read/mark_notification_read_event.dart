part of 'mark_notification_read_bloc.dart';

sealed class MarkNotificationReadEvent extends Equatable {
  const MarkNotificationReadEvent();
}

class UserMarkNotificationReadEvent extends MarkNotificationReadEvent {
  final String url;
  final String? notificationUuid;

  const UserMarkNotificationReadEvent({
    required this.url,
    this.notificationUuid,
  });

  @override
  List<Object?> get props => [url, notificationUuid];
}
