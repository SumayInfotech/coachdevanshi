import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../models/common_model.dart';
import '../../../repository/home_repo.dart';

part 'save_daily_checkin_event.dart';
part 'save_daily_checkin_state.dart';

class SaveDailyCheckinBloc extends Bloc<SaveDailyCheckinEvent, SaveDailyCheckinState> {
  final HomeRepo _homeRepo;

  SaveDailyCheckinBloc({
    required HomeRepo homeRepo,
  })  : _homeRepo = homeRepo,
        super(SaveDailyCheckinInitial()) {
    on<UserSaveDailyCheckinEvent>(_onSaveDailyCheckinEvent);
  }

  Future<void> _onSaveDailyCheckinEvent(
    UserSaveDailyCheckinEvent event,
    Emitter<SaveDailyCheckinState> emit,
  ) async {
    emit(SaveDailyCheckinLoading());

    final response = await _homeRepo.saveDailyCheckins(url: event.url, body: event.body);
    if (response.status) {
      emit(SaveDailyCheckinSuccess(model: response.data));
    } else {
      emit(SaveDailyCheckinFailed(message: response.message));
    }
  }
}
