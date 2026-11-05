import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../models/profile/chapter_six_model.dart';
import '../../../repository/profile_repo.dart';

part 'chapter_six_event.dart';
part 'chapter_six_state.dart';

class ChapterSixBloc extends Bloc<ChapterSixEvent, ChapterSixState> {
  final ProfileRepo _profileRepo;

  ChapterSixBloc({
    required ProfileRepo profileRepo,
  }) : _profileRepo = profileRepo, super(ChapterSixInitial()) {
    on<UserChapterSixEvent>(_onChapterSixEvent);
  }

  Future<void> _onChapterSixEvent(UserChapterSixEvent event, Emitter<ChapterSixState> emit) async {
    emit(ChapterSixLoading());

    final response = await _profileRepo.chaptersSix(url: event.url);
    if (response.status) {
      emit(ChapterSixSuccess(model: response.data));
    } else {
      emit(ChapterSixFailed(message: response.message));
    }
  }
}
