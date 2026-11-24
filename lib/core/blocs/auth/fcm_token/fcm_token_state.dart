part of 'fcm_token_bloc.dart';

sealed class FcmTokenState extends Equatable {
  const FcmTokenState();
}

final class FcmTokenInitial extends FcmTokenState {
  @override
  List<Object> get props => [];
}

final class FcmTokenLoading extends FcmTokenState {
  @override
  List<Object> get props => [];
}

final class FcmTokenSuccess extends FcmTokenState {
  final CommonModel model;

  const FcmTokenSuccess({required this.model});

  @override
  List<Object> get props => [model];
}

final class FcmTokenFailed extends FcmTokenState {
  final String message;

  const FcmTokenFailed({required this.message});

  @override
  List<Object> get props => [message];
}
