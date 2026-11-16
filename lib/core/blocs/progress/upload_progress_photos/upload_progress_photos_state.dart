part of 'upload_progress_photos_bloc.dart';

sealed class UploadProgressPhotosState extends Equatable {
  const UploadProgressPhotosState();
}

final class UploadProgressPhotosInitial extends UploadProgressPhotosState {
  @override
  List<Object> get props => [];
}

final class UploadProgressPhotosLoading extends UploadProgressPhotosState {
  @override
  List<Object> get props => [];
}

final class UploadProgressPhotosSuccess extends UploadProgressPhotosState {
  final CommonModel model;

  const UploadProgressPhotosSuccess({required this.model});

  @override
  List<Object> get props => [model];
}

final class UploadProgressPhotosFailed extends UploadProgressPhotosState {
  final String message;

  const UploadProgressPhotosFailed({required this.message});

  @override
  List<Object> get props => [message];
}
