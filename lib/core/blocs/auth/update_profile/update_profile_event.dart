part of 'update_profile_bloc.dart';

sealed class UpdateProfileEvent extends Equatable {
  const UpdateProfileEvent();
}

class UserUpdateProfileEvent extends UpdateProfileEvent {
  final String url;
  final Map<String, dynamic> body;
  final bool isMultipart;

  const UserUpdateProfileEvent({
    required this.url,
    required this.body,
    this.isMultipart = false,
  });

  @override
  List<Object?> get props => [url, body, isMultipart];
}
