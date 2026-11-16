import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../repository/coach_repo.dart';
import 'rooted_recovery_new_moms_event.dart';
import 'rooted_recovery_new_moms_state.dart';

class RootedRecoveryNewMomsBloc extends Bloc<RootedRecoveryNewMomsEvent, RootedRecoveryNewMomsState> {
  final CoachRepo coachRepo;

  RootedRecoveryNewMomsBloc({
    required this.coachRepo,
  }) : super(RootedRecoveryNewMomsInitial()) {
    on<UserGetRootedRecoveryNewMomsEvent>(_onGetRootedRecoveryNewMomsEvent);
  }

  Future<void> _onGetRootedRecoveryNewMomsEvent(
    UserGetRootedRecoveryNewMomsEvent event,
    Emitter<RootedRecoveryNewMomsState> emit,
  ) async {
    emit(RootedRecoveryNewMomsLoading());

    final response = await coachRepo.getRootedRecoveryNewMoms(url: event.url);

    if (response.status && response.data != null) {
      emit(RootedRecoveryNewMomsSuccess(model: response.data!));
    } else {
      emit(RootedRecoveryNewMomsFailed(message: response.message));
    }
  }
}
