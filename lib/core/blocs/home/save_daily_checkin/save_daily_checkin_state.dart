part of 'save_daily_checkin_bloc.dart';

sealed class SaveDailyCheckinState extends Equatable {
  const SaveDailyCheckinState();
}

final class SaveDailyCheckinInitial extends SaveDailyCheckinState {
  @override
  List<Object> get props => [];
}

final class SaveDailyCheckinLoading extends SaveDailyCheckinState {
  @override
  List<Object> get props => [];
}

final class SaveDailyCheckinSuccess extends SaveDailyCheckinState {
  final CommonModel model;

  const SaveDailyCheckinSuccess({required this.model});

  @override
  List<Object> get props => [model];
}

final class SaveDailyCheckinFailed extends SaveDailyCheckinState {
  final String message;

  const SaveDailyCheckinFailed({required this.message});

  @override
  List<Object> get props => [message];
}
