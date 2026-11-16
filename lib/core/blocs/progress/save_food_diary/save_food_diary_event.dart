part of 'save_food_diary_bloc.dart';

sealed class SaveFoodDiaryEvent extends Equatable {
  const SaveFoodDiaryEvent();
}

class UserSaveFoodDiaryEvent extends SaveFoodDiaryEvent {
  final String url;
  final Map<String, dynamic> body;

  const UserSaveFoodDiaryEvent({required this.url, required this.body});

  @override
  List<Object?> get props => [url, body];
}
