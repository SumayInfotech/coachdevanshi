part of 'dashboard_bloc.dart';

sealed class DashboardState extends Equatable {
  const DashboardState();
}

final class DashboardInitial extends DashboardState {
  @override
  List<Object> get props => [];
}

final class DashboardLoading extends DashboardState {
  @override
  List<Object> get props => [];
}

final class DashboardSuccess extends DashboardState {
  final DashboardModel model;

  const DashboardSuccess({required this.model});

  @override
  List<Object> get props => [model];
}

final class DashboardFailed extends DashboardState {
  final String message;

  const DashboardFailed({required this.message});

  @override
  List<Object> get props => [message];
}
