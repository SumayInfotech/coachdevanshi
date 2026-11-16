import 'package:equatable/equatable.dart';

sealed class GutResetEvent extends Equatable {
  const GutResetEvent();

  @override
  List<Object?> get props => [];
}

class UserGetGutResetEvent extends GutResetEvent {
  final String url;

  const UserGetGutResetEvent({required this.url});

  @override
  List<Object?> get props => [url];
}
