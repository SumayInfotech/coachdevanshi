part of 'save_food_diary_bloc.dart';

sealed class SaveFoodDiaryState extends Equatable {
  const SaveFoodDiaryState();
}

final class SaveFoodDiaryInitial extends SaveFoodDiaryState {
  @override
  List<Object> get props => [];
}

final class SaveFoodDiaryLoading extends SaveFoodDiaryState {
  @override
  List<Object> get props => [];
}

final class SaveFoodDiarySuccess extends SaveFoodDiaryState {
  final CommonModel model;

  const SaveFoodDiarySuccess({required this.model});

  @override
  List<Object> get props => [model];
}

final class SaveFoodDiaryFailed extends SaveFoodDiaryState {
  final String message;

  const SaveFoodDiaryFailed({required this.message});

  @override
  List<Object> get props => [message];
}
