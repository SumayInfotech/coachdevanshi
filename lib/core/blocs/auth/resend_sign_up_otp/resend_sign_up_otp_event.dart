part of 'resend_sign_up_otp_bloc.dart';

sealed class ResendSignUpOtpEvent extends Equatable {
  const ResendSignUpOtpEvent();
}

class UserResendSignUpOtpEvent extends ResendSignUpOtpEvent {

  final String url;
  final Map<String, dynamic> body;

  const new({required this.url, required this.body});

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
