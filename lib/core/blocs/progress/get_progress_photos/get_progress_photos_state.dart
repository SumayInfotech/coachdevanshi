part of 'get_progress_photos_bloc.dart';

sealed class GetProgressPhotosState extends Equatable {
  const GetProgressPhotosState();
}

final class GetProgressPhotosInitial extends GetProgressPhotosState {
  @override
  List<Object> get props => [];
}

final class GetProgressPhotosLoading extends GetProgressPhotosState {
  @override
  List<Object> get props => [];
}

final class GetProgressPhotosSuccess extends GetProgressPhotosState {
  final ProgressPhotosModel model;

  const GetProgressPhotosSuccess({required this.model});

  @override
  List<Object> get props => [model];
}

final class GetProgressPhotosFailed extends GetProgressPhotosState {
  final String message;

  const GetProgressPhotosFailed({required this.message});

  @override
  List<Object> get props => [message];
}
