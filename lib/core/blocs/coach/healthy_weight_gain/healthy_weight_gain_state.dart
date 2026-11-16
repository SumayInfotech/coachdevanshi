import 'package:equatable/equatable.dart';

import '../../../models/coach/healthy_weight_gain_model.dart';

sealed class HealthyWeightGainState extends Equatable {
  const HealthyWeightGainState();

  @override
  List<Object?> get props => [];
}

final class HealthyWeightGainInitial extends HealthyWeightGainState {}

final class HealthyWeightGainLoading extends HealthyWeightGainState {}

final class HealthyWeightGainSuccess extends HealthyWeightGainState {
  final HealthyWeightGainModel model;

  const HealthyWeightGainSuccess({required this.model});

  @override
  List<Object?> get props => [model];
}

final class HealthyWeightGainFailed extends HealthyWeightGainState {
  final String message;

  const HealthyWeightGainFailed({required this.message});

  @override
  List<Object?> get props => [message];
}
