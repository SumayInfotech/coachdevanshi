import 'package:equatable/equatable.dart';

import '../../../models/common_model.dart';

sealed class DeleteFileBloodReportsState extends Equatable {
  const DeleteFileBloodReportsState();

  @override
  List<Object?> get props => [];
}

final class DeleteFileBloodReportsInitial extends DeleteFileBloodReportsState {}

final class DeleteFileBloodReportsLoading extends DeleteFileBloodReportsState {}

final class DeleteFileBloodReportsSuccess extends DeleteFileBloodReportsState {
  final CommonModel model;

  const DeleteFileBloodReportsSuccess({required this.model});

  @override
  List<Object?> get props => [model];
}

final class DeleteFileBloodReportsFailed extends DeleteFileBloodReportsState {
  final String message;

  const DeleteFileBloodReportsFailed({required this.message});

  @override
  List<Object?> get props => [message];
}
