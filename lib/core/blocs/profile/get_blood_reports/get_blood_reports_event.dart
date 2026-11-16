import 'package:equatable/equatable.dart';

sealed class GetBloodReportsEvent extends Equatable {
  const GetBloodReportsEvent();

  @override
  List<Object?> get props => [];
}

class UserGetBloodReportsEvent extends GetBloodReportsEvent {
  final String url;

  const UserGetBloodReportsEvent({required this.url});

  @override
  List<Object?> get props => [url];
}
