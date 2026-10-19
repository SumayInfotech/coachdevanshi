import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../models/auth/user_model.dart';
import '../../../repository/auth_repo.dart';

part 'verify_otp_event.dart';
part 'verify_otp_state.dart';

class VerifyOTPBloc extends Bloc<VerifyOTPEvent, VerifyOTPState> {

  final AuthRepo _authRepo;

  VerifyOTPBloc({
    required this._authRepo,
  }) : super(VerifyOTPInitial()) {
    on<UserVerifyOTPEvent>(_onVerifyOTPEvent);
  }

  Future<void> _onVerifyOTPEvent(UserVerifyOTPEvent event, Emitter<VerifyOTPState> emit) async {
    emit(VerifyOTPLoading());

    final response = await _authRepo.verifyOTP(url: event.url, body: event.body);
    if (response.status) {
      emit(VerifyOTPSuccess(model: response.data));
    } else {
      emit(VerifyOTPFailed(message: response.message));
    }
  }
}
