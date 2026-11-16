import 'package:equatable/equatable.dart';

import '../../../models/coach/pathways_model.dart';

sealed class PathwaysState extends Equatable {
  const PathwaysState();

  @override
  List<Object?> get props => [];
}

final class PathwaysInitial extends PathwaysState {}

final class PathwaysLoading extends PathwaysState {}

final class PathwaysSuccess extends PathwaysState {
  final PathwaysModel model;

  const PathwaysSuccess({required this.model});

  @override
  List<Object?> get props => [model];
}

final class PathwaysFailed extends PathwaysState {
  final String message;

  const PathwaysFailed({required this.message});

  @override
  List<Object?> get props => [message];
}
