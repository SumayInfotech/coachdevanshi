import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../models/common_model.dart';
import '../../../repository/progress_repo.dart';

part 'save_weekly_checkin_event.dart';
part 'save_weekly_checkin_state.dart';

class SaveWeeklyCheckinBloc extends Bloc<SaveWeeklyCheckinEvent, SaveWeeklyCheckinState> {
  final ProgressRepo progressRepo;

  SaveWeeklyCheckinBloc({
    required this.progressRepo,
  }) : super(SaveWeeklyCheckinInitial()) {
    on<UserSaveWeeklyCheckinEvent>(_onSaveWeeklyCheckinEvent);
  }

  Future<void> _onSaveWeeklyCheckinEvent(
    UserSaveWeeklyCheckinEvent event,
    Emitter<SaveWeeklyCheckinState> emit,
  ) async {
    emit(SaveWeeklyCheckinLoading());

    final response = await progressRepo.saveWeeklyCheckins(url: event.url, body: event.body);
    if (response.status) {
      emit(SaveWeeklyCheckinSuccess(model: response.data));
    } else {
      emit(SaveWeeklyCheckinFailed(message: response.message));
    }
  }
}
