part of 'chat_bloc.dart';

sealed class ChatState extends Equatable {
  const ChatState();
}

final class ChatInitial extends ChatState {
  @override
  List<Object?> get props => [];
}

final class ChatLoading extends ChatState {
  @override
  List<Object?> get props => [];
}

final class ChatMessagesSuccess extends ChatState {
  final ChatMessagesModel model;
  final bool isLoadMore;

  const ChatMessagesSuccess({
    required this.model,
    this.isLoadMore = false,
  });

  @override
  List<Object?> get props => [model, isLoadMore];
}

final class ChatMessagesFailed extends ChatState {
  final String message;

  const ChatMessagesFailed({required this.message});

  @override
  List<Object?> get props => [message];
}

final class ChatMessageSending extends ChatState {
  final ChatMessageItem? optimisticMessage;

  const ChatMessageSending({this.optimisticMessage});

  @override
  List<Object?> get props => [optimisticMessage];
}

final class ChatMessageSentSuccess extends ChatState {
  final CommonModel model;
  final ChatMessageItem? localMessage;

  const ChatMessageSentSuccess({
    required this.model,
    this.localMessage,
  });

  @override
  List<Object?> get props => [model, localMessage];
}

final class ChatMessageSentFailed extends ChatState {
  final String message;
  final ChatMessageItem? localMessage;

  const ChatMessageSentFailed({
    required this.message,
    this.localMessage,
  });

  @override
  List<Object?> get props => [message, localMessage];
}
