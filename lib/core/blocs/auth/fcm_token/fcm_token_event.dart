part of 'fcm_token_bloc.dart';

sealed class FcmTokenEvent extends Equatable {
  const FcmTokenEvent();
}

class UserFcmTokenEvent extends FcmTokenEvent {
  final String url;
  final Map<String, dynamic> body;

  const UserFcmTokenEvent({required this.url, required this.body});

  @override
  List<Object?> get props => [url, body];
}
