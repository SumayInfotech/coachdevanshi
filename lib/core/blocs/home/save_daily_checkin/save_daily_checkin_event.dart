part of 'save_daily_checkin_bloc.dart';

sealed class SaveDailyCheckinEvent extends Equatable {
  const SaveDailyCheckinEvent();
}

class UserSaveDailyCheckinEvent extends SaveDailyCheckinEvent {
  final String url;
  final Map<String, dynamic> body;

  const UserSaveDailyCheckinEvent({required this.url, required this.body});

  @override
  List<Object?> get props => [url, body];
}
