part of 'update_profile_bloc.dart';

sealed class UpdateProfileState extends Equatable {
  const UpdateProfileState();
}

final class UpdateProfileInitial extends UpdateProfileState {
  @override
  List<Object> get props => [];
}

final class UpdateProfileLoading extends UpdateProfileState {
  @override
  List<Object> get props => [];
}

final class UpdateProfileSuccess extends UpdateProfileState {
  final UserModel model;

  const UpdateProfileSuccess({required this.model});

  @override
  List<Object> get props => [model];
}

final class UpdateProfileFailed extends UpdateProfileState {
  final String message;

  const UpdateProfileFailed({required this.message});

  @override
  List<Object> get props => [message];
}
