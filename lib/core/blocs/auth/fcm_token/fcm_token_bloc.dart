import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../models/common_model.dart';
import '../../../repository/auth_repo.dart';

part 'fcm_token_event.dart';
part 'fcm_token_state.dart';

class FcmTokenBloc extends Bloc<FcmTokenEvent, FcmTokenState> {
  final AuthRepo authRepo;

  FcmTokenBloc({
    required this.authRepo,
  }) : super(FcmTokenInitial()) {
    on<UserFcmTokenEvent>(_onFcmTokenEvent);
  }

  Future<void> _onFcmTokenEvent(
    UserFcmTokenEvent event,
    Emitter<FcmTokenState> emit,
  ) async {
    emit(FcmTokenLoading());

    final response = await authRepo.fcmToken(url: event.url, body: event.body);
    if (response.status) {
      emit(FcmTokenSuccess(model: response.data));
    } else {
      emit(FcmTokenFailed(message: response.message));
    }
  }
}
