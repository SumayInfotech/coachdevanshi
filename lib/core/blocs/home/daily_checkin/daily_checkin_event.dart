part of 'daily_checkin_bloc.dart';

sealed class DailyCheckinEvent extends Equatable {
  const DailyCheckinEvent();
}

class UserDailyCheckinEvent extends DailyCheckinEvent {
  final String url;

  const UserDailyCheckinEvent({required this.url});

  @override
  List<Object?> get props => [url];
}
