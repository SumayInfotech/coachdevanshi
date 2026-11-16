import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../models/progress/weekly_checkin_model.dart';
import '../../../repository/progress_repo.dart';

part 'weekly_checkin_event.dart';
part 'weekly_checkin_state.dart';

class WeeklyCheckinBloc extends Bloc<WeeklyCheckinEvent, WeeklyCheckinState> {
  final ProgressRepo progressRepo;

  WeeklyCheckinBloc({
    required this.progressRepo,
  }) : super(WeeklyCheckinInitial()) {
    on<UserWeeklyCheckinEvent>(_onWeeklyCheckinEvent);
  }

  Future<void> _onWeeklyCheckinEvent(
    UserWeeklyCheckinEvent event,
    Emitter<WeeklyCheckinState> emit,
  ) async {
    emit(WeeklyCheckinLoading());

    final response = await progressRepo.getWeeklyCheckin(url: event.url);
    if (response.status) {
      emit(WeeklyCheckinSuccess(model: response.data));
    } else {
      emit(WeeklyCheckinFailed(message: response.message));
    }
  }
}
