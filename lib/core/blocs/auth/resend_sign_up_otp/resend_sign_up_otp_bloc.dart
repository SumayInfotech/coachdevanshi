import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../models/common_model.dart';
import '../../../repository/auth_repo.dart';

part 'resend_sign_up_otp_event.dart';
part 'resend_sign_up_otp_state.dart';

class ResendSignUpOtpBloc extends Bloc<ResendSignUpOtpEvent, ResendSignUpOtpState> {

  final AuthRepo _authRepo;

  ResendSignUpOtpBloc({
    required this._authRepo,
  }) : super(ResendSignUpOtpInitial()) {
    on<UserResendSignUpOtpEvent>(_onResendSignUpOtpEvent);
  }

  Future<void> _onResendSignUpOtpEvent(UserResendSignUpOtpEvent event, Emitter<ResendSignUpOtpState> emit) async {
    emit(ResendSignUpOtpLoading());

    final response = await _authRepo.resendSignUpOtp(url: event.url, body: event.body);
    if (response.status) {
      emit(ResendSignUpOtpSuccess(model: response.data));
    } else {
      emit(ResendSignUpOtpFailed(message: response.message));
    }
  }
}
