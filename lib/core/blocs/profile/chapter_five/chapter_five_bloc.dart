import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../models/profile/chapter_five_model.dart';
import '../../../repository/profile_repo.dart';

part 'chapter_five_event.dart';
part 'chapter_five_state.dart';

class ChapterFiveBloc extends Bloc<ChapterFiveEvent, ChapterFiveState> {
  final ProfileRepo _profileRepo;

  ChapterFiveBloc({
    required ProfileRepo profileRepo,
  }) : _profileRepo = profileRepo, super(ChapterFiveInitial()) {
    on<UserChapterFiveEvent>(_onChapterFiveEvent);
  }

  Future<void> _onChapterFiveEvent(UserChapterFiveEvent event, Emitter<ChapterFiveState> emit) async {
    emit(ChapterFiveLoading());

    final response = await _profileRepo.chaptersFive(url: event.url);
    if (response.status) {
      emit(ChapterFiveSuccess(model: response.data));
    } else {
      emit(ChapterFiveFailed(message: response.message));
    }
  }
}
