import 'package:equatable/equatable.dart';

sealed class RootedRecoveryNewMomsEvent extends Equatable {
  const RootedRecoveryNewMomsEvent();

  @override
  List<Object?> get props => [];
}

class UserGetRootedRecoveryNewMomsEvent extends RootedRecoveryNewMomsEvent {
  final String url;

  const UserGetRootedRecoveryNewMomsEvent({required this.url});

  @override
  List<Object?> get props => [url];
}
