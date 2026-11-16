part of 'weekly_checkin_bloc.dart';

sealed class WeeklyCheckinState extends Equatable {
  const WeeklyCheckinState();
}

final class WeeklyCheckinInitial extends WeeklyCheckinState {
  @override
  List<Object> get props => [];
}

final class WeeklyCheckinLoading extends WeeklyCheckinState {
  @override
  List<Object> get props => [];
}

final class WeeklyCheckinSuccess extends WeeklyCheckinState {
  final WeeklyCheckinModel model;

  const WeeklyCheckinSuccess({required this.model});

  @override
  List<Object> get props => [model];
}

final class WeeklyCheckinFailed extends WeeklyCheckinState {
  final String message;

  const WeeklyCheckinFailed({required this.message});

  @override
  List<Object> get props => [message];
}
