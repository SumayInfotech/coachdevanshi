import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../models/profile/chapter_one_model.dart';
import '../../../repository/profile_repo.dart';

part 'chapter_one_event.dart';
part 'chapter_one_state.dart';

class ChapterOneBloc extends Bloc<ChapterOneEvent, ChapterOneState> {

  final ProfileRepo _profileRepo;

  ChapterOneBloc({
    required this._profileRepo,
  }) : super(ChapterOneInitial()) {
    on<UserChapterOneEvent>(_onChapterOneEvent);
  }

  Future<void> _onChapterOneEvent(UserChapterOneEvent event, Emitter<ChapterOneState> emit) async {
    emit(ChapterOneLoading());

    final response = await _profileRepo.chaptersOne(url: event.url);
    if (response.status) {
      emit(ChapterOneSuccess(model: response.data));
    } else {
      emit(ChapterOneFailed(message: response.message));
    }
  }
}
