import 'package:equatable/equatable.dart';

import '../../../models/coach/maintenance_lifestyle_model.dart';

sealed class MaintenanceLifestyleState extends Equatable {
  const MaintenanceLifestyleState();

  @override
  List<Object?> get props => [];
}

final class MaintenanceLifestyleInitial extends MaintenanceLifestyleState {}

final class MaintenanceLifestyleLoading extends MaintenanceLifestyleState {}

final class MaintenanceLifestyleSuccess extends MaintenanceLifestyleState {
  final MaintenanceLifestyleModel model;

  const MaintenanceLifestyleSuccess({required this.model});

  @override
  List<Object?> get props => [model];
}

final class MaintenanceLifestyleFailed extends MaintenanceLifestyleState {
  final String message;

  const MaintenanceLifestyleFailed({required this.message});

  @override
  List<Object?> get props => [message];
}
