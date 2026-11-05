import 'package:coach_devanshi_doshi/core/models/common_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../repository/profile_repo.dart';

part 'save_chapter_event.dart';
part 'save_chapter_state.dart';

class SaveChapterBloc extends Bloc<SaveChapterEvent, SaveChapterState> {

  final ProfileRepo _profileRepo;

  SaveChapterBloc({
    required this._profileRepo,
  }) : super(SaveChapterInitial()) {
    on<UserSaveChapterEvent>(_onSaveChapterEvent);
  }

  Future<void> _onSaveChapterEvent(UserSaveChapterEvent event, Emitter<SaveChapterState> emit) async {
    emit(SaveChapterLoading());

    final response = await _profileRepo.saveChaptersOne(url: event.url, body: event.body);
    if (response.status) {
      emit(SaveChapterSuccess(model: response.data));
    } else {
      emit(SaveChapterFailed(message: response.message));
    }
  }
}
