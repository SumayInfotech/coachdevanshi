import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../repository/profile_repo.dart';
import 'upload_blood_report_event.dart';
import 'upload_blood_report_state.dart';

class UploadBloodReportBloc extends Bloc<UploadBloodReportEvent, UploadBloodReportState> {
  final ProfileRepo profileRepo;

  UploadBloodReportBloc({
    required this.profileRepo,
  }) : super(UploadBloodReportInitial()) {
    on<UserUploadBloodReportEvent>(_onUploadBloodReportEvent);
  }

  Future<void> _onUploadBloodReportEvent(
    UserUploadBloodReportEvent event,
    Emitter<UploadBloodReportState> emit,
  ) async {
    emit(UploadBloodReportLoading());

    final response = await profileRepo.uploadBloodReport(
      url: event.url,
      body: event.body,
    );

    if (response.status) {
      emit(UploadBloodReportSuccess(model: response.data));
    } else {
      emit(UploadBloodReportFailed(message: response.message));
    }
  }
}
