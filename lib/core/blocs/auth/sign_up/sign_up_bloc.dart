import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../models/auth/sign_up_model.dart';
import '../../../repository/auth_repo.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {

  final AuthRepo _authRepo;

  SignUpBloc({
    required this._authRepo,
  }) : super(SignUpInitial()) {
    on<UserSignUpEvent>(_onSignUpEvent);
  }

  Future<void> _onSignUpEvent(UserSignUpEvent event, Emitter<SignUpState> emit) async {
    emit(SignUpLoading());

    final response = await _authRepo.signUp(url: event.url, body: event.body);
    if (response.status) {
      emit(SignUpSuccess(model: response.data));
    } else {
      emit(SignUpFailed(message: response.message));
    }
  }
}
