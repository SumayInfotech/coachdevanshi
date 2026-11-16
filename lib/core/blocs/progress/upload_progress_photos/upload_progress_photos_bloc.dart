import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../models/common_model.dart';
import '../../../repository/progress_repo.dart';

part 'upload_progress_photos_event.dart';
part 'upload_progress_photos_state.dart';

class UploadProgressPhotosBloc extends Bloc<UploadProgressPhotosEvent, UploadProgressPhotosState> {
  final ProgressRepo progressRepo;

  UploadProgressPhotosBloc({
    required this.progressRepo,
  }) : super(UploadProgressPhotosInitial()) {
    on<UserUploadProgressPhotosEvent>(_onUploadProgressPhotosEvent);
  }

  Future<void> _onUploadProgressPhotosEvent(
    UserUploadProgressPhotosEvent event,
    Emitter<UploadProgressPhotosState> emit,
  ) async {
    emit(UploadProgressPhotosLoading());

    final response = await progressRepo.uploadProgressPhotos(url: event.url, body: event.body);
    if (response.status) {
      emit(UploadProgressPhotosSuccess(model: response.data));
    } else {
      emit(UploadProgressPhotosFailed(message: response.message));
    }
  }
}
