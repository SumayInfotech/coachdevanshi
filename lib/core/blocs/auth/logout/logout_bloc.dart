import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';


import '../../../models/common_model.dart';
import '../../../repository/auth_repo.dart';

part 'logout_event.dart';
part 'logout_state.dart';

class LogoutBloc extends Bloc<LogoutEvent, LogoutState> {

  final AuthRepo _authRepo;

  LogoutBloc({
    required this._authRepo,
  }) : super(LogoutInitial()) {
    on<UserLogoutEvent>(_onLogoutEvent);
  }

  Future<void> _onLogoutEvent(UserLogoutEvent event, Emitter<LogoutState> emit) async {
    emit(LogoutLoading());

    final response = await _authRepo.logout(url: event.url, body: event.body);
    if (response.status) {
      emit(LogoutSuccess(model: response.data));
    } else {
      emit(LogoutFailed(message: response.message));
    }
  }
}
