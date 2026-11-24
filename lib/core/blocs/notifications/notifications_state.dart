part of 'notifications_bloc.dart';

sealed class NotificationsState extends Equatable {
  const NotificationsState();
}

final class NotificationsInitial extends NotificationsState {
  @override
  List<Object> get props => [];
}

final class NotificationsLoading extends NotificationsState {
  @override
  List<Object> get props => [];
}

final class NotificationsSuccess extends NotificationsState {
  final NotificationsModel model;

  const NotificationsSuccess({required this.model});

  @override
  List<Object> get props => [model];
}

final class NotificationsFailed extends NotificationsState {
  final String message;

  const NotificationsFailed({required this.message});

  @override
  List<Object> get props => [message];
}
