import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../models/profile/chapter_three_model.dart';
import '../../../repository/profile_repo.dart';

part 'chapter_three_event.dart';
part 'chapter_three_state.dart';

class ChapterThreeBloc extends Bloc<ChapterThreeEvent, ChapterThreeState> {
  final ProfileRepo _profileRepo;

  ChapterThreeBloc({
    required this._profileRepo,
  }) : super(ChapterThreeInitial()) {
    on<UserChapterThreeEvent>(_onChapterThreeEvent);
  }

  Future<void> _onChapterThreeEvent(UserChapterThreeEvent event, Emitter<ChapterThreeState> emit) async {
    emit(ChapterThreeLoading());

    final response = await _profileRepo.chaptersThree(url: event.url);
    if (response.status) {
      emit(ChapterThreeSuccess(model: response.data));
    } else {
      emit(ChapterThreeFailed(message: response.message));
    }
  }
}
