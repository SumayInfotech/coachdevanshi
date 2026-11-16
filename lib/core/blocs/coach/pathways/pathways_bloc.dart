import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../repository/coach_repo.dart';
import 'pathways_event.dart';
import 'pathways_state.dart';

class PathwaysBloc extends Bloc<PathwaysEvent, PathwaysState> {
  final CoachRepo coachRepo;

  PathwaysBloc({
    required this.coachRepo,
  }) : super(PathwaysInitial()) {
    on<UserGetPathwaysEvent>(_onGetPathwaysEvent);
  }

  Future<void> _onGetPathwaysEvent(
    UserGetPathwaysEvent event,
    Emitter<PathwaysState> emit,
  ) async {
    emit(PathwaysLoading());

    final response = await coachRepo.getPathways(url: event.url);

    if (response.status && response.data != null) {
      emit(PathwaysSuccess(model: response.data!));
    } else {
      emit(PathwaysFailed(message: response.message));
    }
  }
}
