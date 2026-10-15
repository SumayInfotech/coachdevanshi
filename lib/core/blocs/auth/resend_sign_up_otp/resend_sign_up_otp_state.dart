part of 'resend_sign_up_otp_bloc.dart';

sealed class ResendSignUpOtpState extends Equatable {
  const ResendSignUpOtpState();
}

final class ResendSignUpOtpInitial extends ResendSignUpOtpState {
  @override
  List<Object> get props => [];
}

final class ResendSignUpOtpLoading extends ResendSignUpOtpState {
  @override
  List<Object> get props => [];
}

final class ResendSignUpOtpSuccess extends ResendSignUpOtpState {
  final CommonModel model;

  const new({required this.model});

  @override
  List<Object> get props => [];
}

final class ResendSignUpOtpFailed extends ResendSignUpOtpState {
  final String message;

  const new({required this.message});

  @override
  List<Object> get props => [];
}
