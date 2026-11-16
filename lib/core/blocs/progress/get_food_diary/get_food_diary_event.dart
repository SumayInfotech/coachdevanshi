part of 'get_food_diary_bloc.dart';

sealed class GetFoodDiaryEvent extends Equatable {
  const GetFoodDiaryEvent();
}

class UserGetFoodDiaryEvent extends GetFoodDiaryEvent {
  final String url;

  const UserGetFoodDiaryEvent({required this.url});

  @override
  List<Object?> get props => [url];
}
