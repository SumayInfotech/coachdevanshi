import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../models/profile/chapter_two_model.dart';
import '../../../repository/profile_repo.dart';

part 'chapter_two_event.dart';
part 'chapter_two_state.dart';

class ChapterTwoBloc extends Bloc<ChapterTwoEvent, ChapterTwoState> {

  final ProfileRepo _profileRepo;

  ChapterTwoBloc({
    required this._profileRepo,
  }) : super(ChapterTwoInitial()) {
    on<UserChapterTwoEvent>(_onChapterTwoEvent);
  }

  Future<void> _onChapterTwoEvent(UserChapterTwoEvent event, Emitter<ChapterTwoState> emit) async {
    emit(ChapterTwoLoading());

    final response = await _profileRepo.chaptersTwo(url: event.url);
    if (response.status) {
      emit(ChapterTwoSuccess(model: response.data));
    } else {
      emit(ChapterTwoFailed(message: response.message));
    }
  }
}
