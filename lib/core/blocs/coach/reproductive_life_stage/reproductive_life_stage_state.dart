import 'package:equatable/equatable.dart';

import '../../../models/coach/reproductive_life_stage_model.dart';

sealed class ReproductiveLifeStageState extends Equatable {
  const ReproductiveLifeStageState();

  @override
  List<Object?> get props => [];
}

final class ReproductiveLifeStageInitial extends ReproductiveLifeStageState {}

final class ReproductiveLifeStageLoading extends ReproductiveLifeStageState {}

final class ReproductiveLifeStageSuccess extends ReproductiveLifeStageState {
  final ReproductiveLifeStageModel model;

  const ReproductiveLifeStageSuccess({required this.model});

  @override
  List<Object?> get props => [model];
}

final class ReproductiveLifeStageFailed extends ReproductiveLifeStageState {
  final String message;

  const ReproductiveLifeStageFailed({required this.message});

  @override
  List<Object?> get props => [message];
}
