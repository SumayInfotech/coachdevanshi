import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../models/auth/user_model.dart';
import '../../../repository/auth_repo.dart';

part 'update_profile_event.dart';
part 'update_profile_state.dart';

class UpdateProfileBloc extends Bloc<UpdateProfileEvent, UpdateProfileState> {

  final AuthRepo _authRepo;

  UpdateProfileBloc({
    required this._authRepo,
  }) : super(UpdateProfileInitial()) {
    on<UserUpdateProfileEvent>(_onUpdateProfileEvent);
  }

  Future<void> _onUpdateProfileEvent(UserUpdateProfileEvent event, Emitter<UpdateProfileState> emit) async {
    emit(UpdateProfileLoading());

    final response = await _authRepo.updateProfile(
      url: event.url,
      body: event.body,
      isMultipart: event.isMultipart,
    );
    if (response.status) {
      emit(UpdateProfileSuccess(model: response.data));
    } else {
      emit(UpdateProfileFailed(message: response.message));
    }
  }
}
