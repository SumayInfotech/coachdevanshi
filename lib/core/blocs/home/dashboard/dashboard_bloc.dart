import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../models/home/dashboard_model.dart';
import '../../../repository/home_repo.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final HomeRepo _homeRepo;

  DashboardBloc({
    required HomeRepo homeRepo,
  }) : _homeRepo = homeRepo, super(DashboardInitial()) {
    on<UserDashboardEvent>(_onDashboardEvent);
  }

  Future<void> _onDashboardEvent(UserDashboardEvent event, Emitter<DashboardState> emit) async {
    emit(DashboardLoading());

    final response = await _homeRepo.getDashboard(url: event.url);
    if (response.status) {
      emit(DashboardSuccess(model: response.data));
    } else {
      emit(DashboardFailed(message: response.message));
    }
  }
}
