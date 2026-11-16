import 'package:equatable/equatable.dart';

sealed class SaveProtocolFormEvent extends Equatable {
  const SaveProtocolFormEvent();

  @override
  List<Object?> get props => [];
}

class UserSaveProtocolFormEvent extends SaveProtocolFormEvent {
  final String url;
  final Map<String, dynamic> body;

  const UserSaveProtocolFormEvent({required this.url, required this.body});

  @override
  List<Object?> get props => [url, body];
}
