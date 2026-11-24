part of 'mark_notification_read_bloc.dart';

sealed class MarkNotificationReadState extends Equatable {
  const MarkNotificationReadState();
}

final class MarkNotificationReadInitial extends MarkNotificationReadState {
  @override
  List<Object> get props => [];
}

final class MarkNotificationReadLoading extends MarkNotificationReadState {
  final String? notificationUuid;

  const MarkNotificationReadLoading({this.notificationUuid});

  @override
  List<Object?> get props => [notificationUuid];
}

final class MarkNotificationReadSuccess extends MarkNotificationReadState {
  final CommonModel model;
  final String? notificationUuid;

  const MarkNotificationReadSuccess({
    required this.model,
    this.notificationUuid,
  });

  @override
  List<Object?> get props => [model, notificationUuid];
}

final class MarkNotificationReadFailed extends MarkNotificationReadState {
  final String message;
  final String? notificationUuid;

  const MarkNotificationReadFailed({
    required this.message,
    this.notificationUuid,
  });

  @override
  List<Object?> get props => [message, notificationUuid];
}
