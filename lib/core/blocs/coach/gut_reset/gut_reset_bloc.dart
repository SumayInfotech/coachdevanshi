import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../repository/coach_repo.dart';
import 'gut_reset_event.dart';
import 'gut_reset_state.dart';

class GutResetBloc extends Bloc<GutResetEvent, GutResetState> {
  final CoachRepo coachRepo;

  GutResetBloc({
    required this.coachRepo,
  }) : super(GutResetInitial()) {
    on<UserGetGutResetEvent>(_onGetGutResetEvent);
  }

  Future<void> _onGetGutResetEvent(
    UserGetGutResetEvent event,
    Emitter<GutResetState> emit,
  ) async {
    emit(GutResetLoading());

    final response = await coachRepo.getGutReset(url: event.url);

    if (response.status && response.data != null) {
      emit(GutResetSuccess(model: response.data!));
    } else {
      emit(GutResetFailed(message: response.message));
    }
  }
}
