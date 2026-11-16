import 'package:equatable/equatable.dart';

import '../../../models/common_model.dart';

sealed class UploadBloodReportState extends Equatable {
  const UploadBloodReportState();

  @override
  List<Object?> get props => [];
}

final class UploadBloodReportInitial extends UploadBloodReportState {}

final class UploadBloodReportLoading extends UploadBloodReportState {}

final class UploadBloodReportSuccess extends UploadBloodReportState {
  final CommonModel model;

  const UploadBloodReportSuccess({required this.model});

  @override
  List<Object?> get props => [model];
}

final class UploadBloodReportFailed extends UploadBloodReportState {
  final String message;

  const UploadBloodReportFailed({required this.message});

  @override
  List<Object?> get props => [message];
}
