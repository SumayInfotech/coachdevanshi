part of 'logout_bloc.dart';

sealed class LogoutState extends Equatable {
  const LogoutState();
}

final class LogoutInitial extends LogoutState {
  @override
  List<Object> get props => [];
}

final class LogoutLoading extends LogoutState {
  @override
  List<Object> get props => [];
}

final class LogoutSuccess extends LogoutState {
  final CommonModel model;

  const new({required this.model});

  @override
  List<Object> get props => [];
}

final class LogoutFailed extends LogoutState {
  final String message;

  const new({required this.message});

  @override
  List<Object> get props => [];
}
