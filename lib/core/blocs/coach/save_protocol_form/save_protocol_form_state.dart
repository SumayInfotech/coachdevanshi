import 'package:equatable/equatable.dart';

import '../../../models/common_model.dart';

sealed class SaveProtocolFormState extends Equatable {
  const SaveProtocolFormState();

  @override
  List<Object?> get props => [];
}

final class SaveProtocolFormInitial extends SaveProtocolFormState {}

final class SaveProtocolFormLoading extends SaveProtocolFormState {}

final class SaveProtocolFormSuccess extends SaveProtocolFormState {
  final CommonModel model;

  const SaveProtocolFormSuccess({required this.model});

  @override
  List<Object?> get props => [model];
}

final class SaveProtocolFormFailed extends SaveProtocolFormState {
  final String message;

  const SaveProtocolFormFailed({required this.message});

  @override
  List<Object?> get props => [message];
}
