import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../models/auth/sign_up_model.dart';
import '../../../repository/auth_repo.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {

  final AuthRepo _authRepo;

  LoginBloc({
    required this._authRepo,
  }) : super(LoginInitial()) {
    on<UserLoginEvent>(_onLoginEvent);
  }

  Future<void> _onLoginEvent(UserLoginEvent event, Emitter<LoginState> emit) async {
    emit(LoginLoading());

    final response = await _authRepo.login(url: event.url, body: event.body);
    if (response.status) {
      emit(LoginSuccess(model: response.data));
    } else {
      emit(LoginFailed(message: response.message));
    }
  }
}
