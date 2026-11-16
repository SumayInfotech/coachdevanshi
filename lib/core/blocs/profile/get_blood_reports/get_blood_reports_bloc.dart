import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../repository/profile_repo.dart';
import 'get_blood_reports_event.dart';
import 'get_blood_reports_state.dart';

class GetBloodReportsBloc extends Bloc<GetBloodReportsEvent, GetBloodReportsState> {
  final ProfileRepo profileRepo;

  GetBloodReportsBloc({
    required this.profileRepo,
  }) : super(GetBloodReportsInitial()) {
    on<UserGetBloodReportsEvent>(_onGetBloodReportsEvent);
  }

  Future<void> _onGetBloodReportsEvent(
    UserGetBloodReportsEvent event,
    Emitter<GetBloodReportsState> emit,
  ) async {
    emit(GetBloodReportsLoading());

    final response = await profileRepo.getBloodReports(url: event.url);

    if (response.status && response.data != null) {
      emit(GetBloodReportsSuccess(model: response.data!));
    } else {
      emit(GetBloodReportsFailed(message: response.message));
    }
  }
}
