import 'package:equatable/equatable.dart';

import '../../../models/coach/gut_reset_model.dart';

sealed class GutResetState extends Equatable {
  const GutResetState();

  @override
  List<Object?> get props => [];
}

final class GutResetInitial extends GutResetState {}

final class GutResetLoading extends GutResetState {}

final class GutResetSuccess extends GutResetState {
  final GutResetModel model;

  const GutResetSuccess({required this.model});

  @override
  List<Object?> get props => [model];
}

final class GutResetFailed extends GutResetState {
  final String message;

  const GutResetFailed({required this.message});

  @override
  List<Object?> get props => [message];
}
