import 'package:equatable/equatable.dart';

import '../../../models/coach/rooted_recovery_new_moms_model.dart';

sealed class RootedRecoveryNewMomsState extends Equatable {
  const RootedRecoveryNewMomsState();

  @override
  List<Object?> get props => [];
}

final class RootedRecoveryNewMomsInitial extends RootedRecoveryNewMomsState {}

final class RootedRecoveryNewMomsLoading extends RootedRecoveryNewMomsState {}

final class RootedRecoveryNewMomsSuccess extends RootedRecoveryNewMomsState {
  final RootedRecoveryNewMomsModel model;

  const RootedRecoveryNewMomsSuccess({required this.model});

  @override
  List<Object?> get props => [model];
}

final class RootedRecoveryNewMomsFailed extends RootedRecoveryNewMomsState {
  final String message;

  const RootedRecoveryNewMomsFailed({required this.message});

  @override
  List<Object?> get props => [message];
}
