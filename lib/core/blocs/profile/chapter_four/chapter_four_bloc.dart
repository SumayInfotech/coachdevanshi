import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../models/profile/chapter_four_model.dart';
import '../../../repository/profile_repo.dart';

part 'chapter_four_event.dart';
part 'chapter_four_state.dart';

class ChapterFourBloc extends Bloc<ChapterFourEvent, ChapterFourState> {
  final ProfileRepo _profileRepo;

  ChapterFourBloc({
    required ProfileRepo profileRepo,
  }) : _profileRepo = profileRepo, super(ChapterFourInitial()) {
    on<UserChapterFourEvent>(_onChapterFourEvent);
  }

  Future<void> _onChapterFourEvent(UserChapterFourEvent event, Emitter<ChapterFourState> emit) async {
    emit(ChapterFourLoading());

    final response = await _profileRepo.chaptersFour(url: event.url);
    if (response.status) {
      emit(ChapterFourSuccess(model: response.data));
    } else {
      emit(ChapterFourFailed(message: response.message));
    }
  }
}
