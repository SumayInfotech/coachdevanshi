part of 'get_progress_photos_bloc.dart';

sealed class GetProgressPhotosEvent extends Equatable {
  const GetProgressPhotosEvent();
}

class UserGetProgressPhotosEvent extends GetProgressPhotosEvent {
  final String url;

  const UserGetProgressPhotosEvent({required this.url});

  @override
  List<Object?> get props => [url];
}
