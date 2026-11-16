import 'package:equatable/equatable.dart';

sealed class DeleteFileBloodReportsEvent extends Equatable {
  const DeleteFileBloodReportsEvent();

  @override
  List<Object?> get props => [];
}

class UserDeleteFileBloodReportsEvent extends DeleteFileBloodReportsEvent {
  final String url;

  const UserDeleteFileBloodReportsEvent({required this.url});

  @override
  List<Object?> get props => [url];
}
