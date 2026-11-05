part of 'daily_checkin_bloc.dart';

sealed class DailyCheckinState extends Equatable {
  const DailyCheckinState();
}

final class DailyCheckinInitial extends DailyCheckinState {
  @override
  List<Object> get props => [];
}

final class DailyCheckinLoading extends DailyCheckinState {
  @override
  List<Object> get props => [];
}

final class DailyCheckinSuccess extends DailyCheckinState {
  final DailyCheckinModel model;

  const DailyCheckinSuccess({required this.model});

  @override
  List<Object> get props => [model];
}

final class DailyCheckinFailed extends DailyCheckinState {
  final String message;

  const DailyCheckinFailed({required this.message});

  @override
  List<Object> get props => [message];
}
