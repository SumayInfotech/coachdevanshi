import 'package:equatable/equatable.dart';

sealed class MaintenanceLifestyleEvent extends Equatable {
  const MaintenanceLifestyleEvent();

  @override
  List<Object?> get props => [];
}

class UserGetMaintenanceLifestyleEvent extends MaintenanceLifestyleEvent {
  final String url;

  const UserGetMaintenanceLifestyleEvent({required this.url});

  @override
  List<Object?> get props => [url];
}
