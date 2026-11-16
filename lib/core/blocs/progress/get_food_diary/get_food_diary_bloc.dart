import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../models/progress/food_diary_model.dart';
import '../../../repository/progress_repo.dart';

part 'get_food_diary_event.dart';
part 'get_food_diary_state.dart';

class GetFoodDiaryBloc extends Bloc<GetFoodDiaryEvent, GetFoodDiaryState> {
  final ProgressRepo progressRepo;

  GetFoodDiaryBloc({
    required this.progressRepo,
  }) : super(GetFoodDiaryInitial()) {
    on<UserGetFoodDiaryEvent>(_onGetFoodDiaryEvent);
  }

  Future<void> _onGetFoodDiaryEvent(
    UserGetFoodDiaryEvent event,
    Emitter<GetFoodDiaryState> emit,
  ) async {
    emit(GetFoodDiaryLoading());

    final response = await progressRepo.getFoodDiary(url: event.url);
    if (response.status) {
      emit(GetFoodDiarySuccess(model: response.data));
    } else {
      emit(GetFoodDiaryFailed(message: response.message));
    }
  }
}
