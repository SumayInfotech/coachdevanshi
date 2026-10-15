import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../models/auth/user_model.dart';
import '../../../repository/auth_repo.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {

  final AuthRepo _authRepo;

  ProfileBloc({
    required this._authRepo,
  }) : super(ProfileInitial()) {
    on<UserProfileEvent>(_onProfileEvent);
  }

  Future<void> _onProfileEvent(UserProfileEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());

    final response = await _authRepo.profile(url: event.url);
    if (response.status) {
      emit(ProfileSuccess(model: response.data));
    } else {
      emit(ProfileFailed(message: response.message));
    }
  }
}
