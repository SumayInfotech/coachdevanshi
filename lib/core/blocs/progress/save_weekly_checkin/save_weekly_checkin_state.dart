part of 'save_weekly_checkin_bloc.dart';

sealed class SaveWeeklyCheckinState extends Equatable {
  const SaveWeeklyCheckinState();
}

final class SaveWeeklyCheckinInitial extends SaveWeeklyCheckinState {
  @override
  List<Object> get props => [];
}

final class SaveWeeklyCheckinLoading extends SaveWeeklyCheckinState {
  @override
  List<Object> get props => [];
}

final class SaveWeeklyCheckinSuccess extends SaveWeeklyCheckinState {
  final CommonModel model;

  const SaveWeeklyCheckinSuccess({required this.model});

  @override
  List<Object> get props => [model];
}

final class SaveWeeklyCheckinFailed extends SaveWeeklyCheckinState {
  final String message;

  const SaveWeeklyCheckinFailed({required this.message});

  @override
  List<Object> get props => [message];
}
