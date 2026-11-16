import 'package:equatable/equatable.dart';

import '../../../models/profile/blood_reports_model.dart';

sealed class GetBloodReportsState extends Equatable {
  const GetBloodReportsState();

  @override
  List<Object?> get props => [];
}

final class GetBloodReportsInitial extends GetBloodReportsState {}

final class GetBloodReportsLoading extends GetBloodReportsState {}

final class GetBloodReportsSuccess extends GetBloodReportsState {
  final BloodReportsModel model;

  const GetBloodReportsSuccess({required this.model});

  @override
  List<Object?> get props => [model];
}

final class GetBloodReportsFailed extends GetBloodReportsState {
  final String message;

  const GetBloodReportsFailed({required this.message});

  @override
  List<Object?> get props => [message];
}
