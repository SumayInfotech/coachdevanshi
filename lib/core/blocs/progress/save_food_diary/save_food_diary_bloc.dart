import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../models/common_model.dart';
import '../../../repository/progress_repo.dart';

part 'save_food_diary_event.dart';
part 'save_food_diary_state.dart';

class SaveFoodDiaryBloc extends Bloc<SaveFoodDiaryEvent, SaveFoodDiaryState> {
  final ProgressRepo progressRepo;

  SaveFoodDiaryBloc({
    required this.progressRepo,
  }) : super(SaveFoodDiaryInitial()) {
    on<UserSaveFoodDiaryEvent>(_onSaveFoodDiaryEvent);
  }

  Future<void> _onSaveFoodDiaryEvent(
    UserSaveFoodDiaryEvent event,
    Emitter<SaveFoodDiaryState> emit,
  ) async {
    emit(SaveFoodDiaryLoading());

    final response = await progressRepo.saveFoodDiary(url: event.url, body: event.body);
    if (response.status) {
      emit(SaveFoodDiarySuccess(model: response.data));
    } else {
      emit(SaveFoodDiaryFailed(message: response.message));
    }
  }
}
