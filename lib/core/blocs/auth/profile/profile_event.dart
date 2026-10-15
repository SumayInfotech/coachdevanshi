part of 'profile_bloc.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();
}

class UserProfileEvent extends ProfileEvent {

  final String url;

  const new({required this.url});

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
