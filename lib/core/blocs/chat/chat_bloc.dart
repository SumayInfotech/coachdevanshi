import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/chat/chat_messages_model.dart';
import '../../models/common_model.dart';
import '../../repository/chat_repo.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepo chatRepo;

  ChatBloc({
    required this.chatRepo,
  }) : super(ChatInitial()) {
    on<UserGetMessagesEvent>(_onGetMessagesEvent);
    on<UserSendMessageEvent>(_onSendMessageEvent);
  }

  Future<void> _onGetMessagesEvent(
    UserGetMessagesEvent event,
    Emitter<ChatState> emit,
  ) async {
    if (!event.isLoadMore) {
      emit(ChatLoading());
    }

    final response = await chatRepo.getMessages(
      url: event.url,
      queryParameters: event.queryParameters,
    );

    if (response.status) {
      emit(ChatMessagesSuccess(
        model: response.data,
        isLoadMore: event.isLoadMore,
      ));
    } else {
      emit(ChatMessagesFailed(message: response.message));
    }
  }

  Future<void> _onSendMessageEvent(
    UserSendMessageEvent event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatMessageSending(optimisticMessage: event.localMessage));

    final response = await chatRepo.sendMessage(
      url: event.url,
      body: event.body,
      isMultipart: event.isMultipart,
    );

    if (response.status) {
      emit(ChatMessageSentSuccess(
        model: response.data,
        localMessage: event.localMessage,
      ));
    } else {
      emit(ChatMessageSentFailed(
        message: response.message,
        localMessage: event.localMessage,
      ));
    }
  }
}
