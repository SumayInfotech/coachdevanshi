import 'package:equatable/equatable.dart';

sealed class PathwaysEvent extends Equatable {
  const PathwaysEvent();

  @override
  List<Object?> get props => [];
}

class UserGetPathwaysEvent extends PathwaysEvent {
  final String url;

  const UserGetPathwaysEvent({required this.url});

  @override
  List<Object?> get props => [url];
}
