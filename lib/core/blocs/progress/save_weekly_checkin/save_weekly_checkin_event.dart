part of 'save_weekly_checkin_bloc.dart';

sealed class SaveWeeklyCheckinEvent extends Equatable {
  const SaveWeeklyCheckinEvent();
}

class UserSaveWeeklyCheckinEvent extends SaveWeeklyCheckinEvent {
  final String url;
  final Map<String, dynamic> body;

  const UserSaveWeeklyCheckinEvent({required this.url, required this.body});

  @override
  List<Object?> get props => [url, body];
}
