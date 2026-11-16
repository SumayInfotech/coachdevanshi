import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../repository/profile_repo.dart';
import 'delete_file_blood_reports_event.dart';
import 'delete_file_blood_reports_state.dart';

class DeleteFileBloodReportsBloc
    extends Bloc<DeleteFileBloodReportsEvent, DeleteFileBloodReportsState> {
  final ProfileRepo profileRepo;

  DeleteFileBloodReportsBloc({
    required this.profileRepo,
  }) : super(DeleteFileBloodReportsInitial()) {
    on<UserDeleteFileBloodReportsEvent>(_onDeleteFileBloodReportsEvent);
  }

  Future<void> _onDeleteFileBloodReportsEvent(
    UserDeleteFileBloodReportsEvent event,
    Emitter<DeleteFileBloodReportsState> emit,
  ) async {
    emit(DeleteFileBloodReportsLoading());

    final response = await profileRepo.deleteFileBloodReports(url: event.url);

    if (response.status && response.data != null) {
      emit(DeleteFileBloodReportsSuccess(model: response.data!));
    } else {
      emit(DeleteFileBloodReportsFailed(message: response.message));
    }
  }
}
