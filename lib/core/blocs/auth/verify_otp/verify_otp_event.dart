part of 'verify_otp_bloc.dart';

sealed class VerifyOTPEvent extends Equatable {
  const VerifyOTPEvent();
}

class UserVerifyOTPEvent extends VerifyOTPEvent {

  final String url;
  final Map<String, dynamic> body;

  const new({required this.url, required this.body});

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
