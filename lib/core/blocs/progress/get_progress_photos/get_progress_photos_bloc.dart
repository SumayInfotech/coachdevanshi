import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../models/progress/progress_photos_model.dart';
import '../../../repository/progress_repo.dart';

part 'get_progress_photos_event.dart';
part 'get_progress_photos_state.dart';

class GetProgressPhotosBloc extends Bloc<GetProgressPhotosEvent, GetProgressPhotosState> {
  final ProgressRepo progressRepo;

  GetProgressPhotosBloc({
    required this.progressRepo,
  }) : super(GetProgressPhotosInitial()) {
    on<UserGetProgressPhotosEvent>(_onGetProgressPhotosEvent);
  }

  Future<void> _onGetProgressPhotosEvent(
    UserGetProgressPhotosEvent event,
    Emitter<GetProgressPhotosState> emit,
  ) async {
    emit(GetProgressPhotosLoading());

    final response = await progressRepo.getProgressPhotos(url: event.url);
    if (response.status) {
      emit(GetProgressPhotosSuccess(model: response.data));
    } else {
      emit(GetProgressPhotosFailed(message: response.message));
    }
  }
}
