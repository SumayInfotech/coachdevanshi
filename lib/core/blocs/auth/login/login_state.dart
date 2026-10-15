part of 'login_bloc.dart';

sealed class LoginState extends Equatable {
  const LoginState();
}

final class LoginInitial extends LoginState {
  @override
  List<Object> get props => [];
}

final class LoginLoading extends LoginState {
  @override
  List<Object> get props => [];
}

final class LoginSuccess extends LoginState {
  final SignUpModel model;

  const new({required this.model});

  @override
  List<Object> get props => [];
}

final class LoginFailed extends LoginState {
  final String message;

  const new({required this.message});

  @override
  List<Object> get props => [];
}
