part of 'social_login_bloc.dart';

sealed class SocialLoginEvent extends Equatable {
  const SocialLoginEvent();
}

class UserSocialLoginEvent extends SocialLoginEvent {

  final String url;
  final Map<String, dynamic> body;

  const new({required this.url, required this.body});

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
