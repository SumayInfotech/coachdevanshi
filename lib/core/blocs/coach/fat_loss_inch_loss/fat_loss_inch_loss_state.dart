import 'package:equatable/equatable.dart';

import '../../../models/coach/fat_loss_inch_loss_model.dart';

sealed class FatLossInchLossState extends Equatable {
  const FatLossInchLossState();

  @override
  List<Object?> get props => [];
}

final class FatLossInchLossInitial extends FatLossInchLossState {}

final class FatLossInchLossLoading extends FatLossInchLossState {}

final class FatLossInchLossSuccess extends FatLossInchLossState {
  final FatLossInchLossModel model;

  const FatLossInchLossSuccess({required this.model});

  @override
  List<Object?> get props => [model];
}

final class FatLossInchLossFailed extends FatLossInchLossState {
  final String message;

  const FatLossInchLossFailed({required this.message});

  @override
  List<Object?> get props => [message];
}
