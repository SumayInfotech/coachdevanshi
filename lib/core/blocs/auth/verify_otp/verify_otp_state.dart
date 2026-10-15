part of 'verify_otp_bloc.dart';

sealed class VerifyOTPState extends Equatable {
  const VerifyOTPState();
}

final class VerifyOTPInitial extends VerifyOTPState {
  @override
  List<Object> get props => [];
}

final class VerifyOTPLoading extends VerifyOTPState {
  @override
  List<Object> get props => [];
}

final class VerifyOTPSuccess extends VerifyOTPState {
  final UserModel model;

  const new({required this.model});

  @override
  List<Object> get props => [];
}

final class VerifyOTPFailed extends VerifyOTPState {
  final String message;

  const new({required this.message});

  @override
  List<Object> get props => [];
}
