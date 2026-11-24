import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/notifications/notifications_model.dart';
import '../../repository/home_repo.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final HomeRepo homeRepo;

  NotificationsBloc({
    required this.homeRepo,
  }) : super(NotificationsInitial()) {
    on<FetchNotificationsEvent>(_onFetchNotificationsEvent);
  }

  Future<void> _onFetchNotificationsEvent(
    FetchNotificationsEvent event,
    Emitter<NotificationsState> emit,
  ) async {
    emit(NotificationsLoading());

    final response = await homeRepo.getNotifications(url: event.url);
    if (response.status) {
      emit(NotificationsSuccess(model: response.data));
    } else {
      emit(NotificationsFailed(message: response.message));
    }
  }
}
