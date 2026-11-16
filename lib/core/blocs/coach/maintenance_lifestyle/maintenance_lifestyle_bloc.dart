import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../repository/coach_repo.dart';
import 'maintenance_lifestyle_event.dart';
import 'maintenance_lifestyle_state.dart';

class MaintenanceLifestyleBloc extends Bloc<MaintenanceLifestyleEvent, MaintenanceLifestyleState> {
  final CoachRepo coachRepo;

  MaintenanceLifestyleBloc({
    required this.coachRepo,
  }) : super(MaintenanceLifestyleInitial()) {
    on<UserGetMaintenanceLifestyleEvent>(_onGetMaintenanceLifestyleEvent);
  }

  Future<void> _onGetMaintenanceLifestyleEvent(
    UserGetMaintenanceLifestyleEvent event,
    Emitter<MaintenanceLifestyleState> emit,
  ) async {
    emit(MaintenanceLifestyleLoading());

    final response = await coachRepo.getMaintenanceLifestyle(url: event.url);

    if (response.status && response.data != null) {
      emit(MaintenanceLifestyleSuccess(model: response.data!));
    } else {
      emit(MaintenanceLifestyleFailed(message: response.message));
    }
  }
}
