part of 'upload_progress_photos_bloc.dart';

sealed class UploadProgressPhotosEvent extends Equatable {
  const UploadProgressPhotosEvent();
}

class UserUploadProgressPhotosEvent extends UploadProgressPhotosEvent {
  final String url;
  final Map<String, dynamic> body;

  const UserUploadProgressPhotosEvent({required this.url, required this.body});

  @override
  List<Object?> get props => [url, body];
}
