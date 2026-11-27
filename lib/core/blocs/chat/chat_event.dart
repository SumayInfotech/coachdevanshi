part of 'chat_bloc.dart';

sealed class ChatEvent extends Equatable {
  const ChatEvent();
}

class UserGetMessagesEvent extends ChatEvent {
  final String url;
  final Map<String, dynamic>? queryParameters;
  final bool isLoadMore;

  const UserGetMessagesEvent({
    required this.url,
    this.queryParameters,
    this.isLoadMore = false,
  });

  @override
  List<Object?> get props => [url, queryParameters, isLoadMore];
}

class UserSendMessageEvent extends ChatEvent {
  final String url;
  final Map<String, dynamic> body;
  final bool isMultipart;
  final ChatMessageItem? localMessage;

  const UserSendMessageEvent({
    required this.url,
    required this.body,
    this.isMultipart = false,
    this.localMessage,
  });

  @override
  List<Object?> get props => [url, body, isMultipart, localMessage];
}
