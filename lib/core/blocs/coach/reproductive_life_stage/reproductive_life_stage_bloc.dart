import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../repository/coach_repo.dart';
import 'reproductive_life_stage_event.dart';
import 'reproductive_life_stage_state.dart';

class ReproductiveLifeStageBloc extends Bloc<ReproductiveLifeStageEvent, ReproductiveLifeStageState> {
  final CoachRepo coachRepo;

  ReproductiveLifeStageBloc({
    required this.coachRepo,
  }) : super(ReproductiveLifeStageInitial()) {
    on<UserGetReproductiveLifeStageEvent>(_onGetReproductiveLifeStageEvent);
  }

  Future<void> _onGetReproductiveLifeStageEvent(
    UserGetReproductiveLifeStageEvent event,
    Emitter<ReproductiveLifeStageState> emit,
  ) async {
    emit(ReproductiveLifeStageLoading());

    final response = await coachRepo.getReproductiveLifeStage(url: event.url);

    if (response.status && response.data != null) {
      emit(ReproductiveLifeStageSuccess(model: response.data!));
    } else {
      emit(ReproductiveLifeStageFailed(message: response.message));
    }
  }
}
