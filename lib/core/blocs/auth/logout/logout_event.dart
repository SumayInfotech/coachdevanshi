part of 'logout_bloc.dart';

sealed class LogoutEvent extends Equatable {
  const LogoutEvent();
}

class UserLogoutEvent extends LogoutEvent {

  final String url;
  final Map<String, dynamic> body;

  const new({required this.url, required this.body});

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
