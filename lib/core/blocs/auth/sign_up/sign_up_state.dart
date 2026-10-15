part of 'sign_up_bloc.dart';

sealed class SignUpState extends Equatable {
  const SignUpState();
}

final class SignUpInitial extends SignUpState {
  @override
  List<Object> get props => [];
}

final class SignUpLoading extends SignUpState {
  @override
  List<Object> get props => [];
}

final class SignUpSuccess extends SignUpState {
  final SignUpModel model;

  const new({required this.model});

  @override
  List<Object> get props => [];
}

final class SignUpFailed extends SignUpState {
  final String message;

  const new({required this.message});

  @override
  List<Object> get props => [];
}
