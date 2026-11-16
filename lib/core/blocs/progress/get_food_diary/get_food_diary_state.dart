part of 'get_food_diary_bloc.dart';

sealed class GetFoodDiaryState extends Equatable {
  const GetFoodDiaryState();
}

final class GetFoodDiaryInitial extends GetFoodDiaryState {
  @override
  List<Object> get props => [];
}

final class GetFoodDiaryLoading extends GetFoodDiaryState {
  @override
  List<Object> get props => [];
}

final class GetFoodDiarySuccess extends GetFoodDiaryState {
  final FoodDiaryModel model;

  const GetFoodDiarySuccess({required this.model});

  @override
  List<Object> get props => [model];
}

final class GetFoodDiaryFailed extends GetFoodDiaryState {
  final String message;

  const GetFoodDiaryFailed({required this.message});

  @override
  List<Object> get props => [message];
}
