part of 'weekly_checkin_bloc.dart';

sealed class WeeklyCheckinEvent extends Equatable {
  const WeeklyCheckinEvent();
}

class UserWeeklyCheckinEvent extends WeeklyCheckinEvent {
  final String url;

  const UserWeeklyCheckinEvent({required this.url});

  @override
  List<Object?> get props => [url];
}
