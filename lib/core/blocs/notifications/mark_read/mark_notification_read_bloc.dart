import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../models/common_model.dart';
import '../../../repository/home_repo.dart';

part 'mark_notification_read_event.dart';
part 'mark_notification_read_state.dart';

class MarkNotificationReadBloc extends Bloc<MarkNotificationReadEvent, MarkNotificationReadState> {
  final HomeRepo homeRepo;

  MarkNotificationReadBloc({
    required this.homeRepo,
  }) : super(MarkNotificationReadInitial()) {
    on<UserMarkNotificationReadEvent>(_onMarkNotificationReadEvent);
  }

  Future<void> _onMarkNotificationReadEvent(
    UserMarkNotificationReadEvent event,
    Emitter<MarkNotificationReadState> emit,
  ) async {
    emit(MarkNotificationReadLoading(notificationUuid: event.notificationUuid));

    final response = await homeRepo.markNotificationRead(url: event.url);
    if (response.status) {
      emit(MarkNotificationReadSuccess(
        model: response.data,
        notificationUuid: event.notificationUuid,
      ));
    } else {
      emit(MarkNotificationReadFailed(
        message: response.message,
        notificationUuid: event.notificationUuid,
      ));
    }
  }
}
