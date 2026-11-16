import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../repository/coach_repo.dart';
import 'healthy_weight_gain_event.dart';
import 'healthy_weight_gain_state.dart';

class HealthyWeightGainBloc extends Bloc<HealthyWeightGainEvent, HealthyWeightGainState> {
  final CoachRepo coachRepo;

  HealthyWeightGainBloc({
    required this.coachRepo,
  }) : super(HealthyWeightGainInitial()) {
    on<UserGetHealthyWeightGainEvent>(_onGetHealthyWeightGainEvent);
  }

  Future<void> _onGetHealthyWeightGainEvent(
    UserGetHealthyWeightGainEvent event,
    Emitter<HealthyWeightGainState> emit,
  ) async {
    emit(HealthyWeightGainLoading());

    final response = await coachRepo.getHealthyWeightGain(url: event.url);

    if (response.status && response.data != null) {
      emit(HealthyWeightGainSuccess(model: response.data!));
    } else {
      emit(HealthyWeightGainFailed(message: response.message));
    }
  }
}
