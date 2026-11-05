part of 'dashboard_bloc.dart';

sealed class DashboardEvent extends Equatable {
  const DashboardEvent();
}

class UserDashboardEvent extends DashboardEvent {
  final String url;

  const UserDashboardEvent({required this.url});

  @override
  List<Object?> get props => [url];
}
