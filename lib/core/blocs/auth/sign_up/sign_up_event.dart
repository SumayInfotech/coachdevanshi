part of 'sign_up_bloc.dart';

sealed class SignUpEvent extends Equatable {
  const SignUpEvent();
}

class UserSignUpEvent extends SignUpEvent {

  final String url;
  final Map<String, dynamic> body;

  const new({required this.url, required this.body});

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
