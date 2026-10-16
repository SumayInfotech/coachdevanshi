part of 'social_login_bloc.dart';

sealed class SocialLoginState extends Equatable {
  const SocialLoginState();
}

final class SocialLoginInitial extends SocialLoginState {
  @override
  List<Object> get props => [];
}

final class SocialLoginLoading extends SocialLoginState {
  @override
  List<Object> get props => [];
}

final class SocialLoginSuccess extends SocialLoginState {
  final UserModel model;

  const new({required this.model});

  @override
  List<Object> get props => [];
}

final class SocialLoginFailed extends SocialLoginState {
  final String message;

  const new({required this.message});

  @override
  List<Object> get props => [];
}
