import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../models/common_model.dart';
import '../../../repository/home_repo.dart';

part 'health_sync_event.dart';
part 'health_sync_state.dart';

class HealthSyncBloc extends Bloc<HealthSyncEvent, HealthSyncState> {
  final HomeRepo homeRepo;

  HealthSyncBloc({
    required this.homeRepo,
  }) : super(HealthSyncInitial()) {
    on<UserHealthSyncEvent>(_onHealthSyncEvent);
  }

  Future<void> _onHealthSyncEvent(
    UserHealthSyncEvent event,
    Emitter<HealthSyncState> emit,
  ) async {
    emit(HealthSyncLoading());

    final response = await homeRepo.syncHealthData(url: event.url, body: event.body);
    if (response.status) {
      emit(HealthSyncSuccess(model: response.data));
    } else {
      emit(HealthSyncFailed(message: response.message));
    }
  }
}
