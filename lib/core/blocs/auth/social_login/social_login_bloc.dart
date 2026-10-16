import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../models/auth/user_model.dart';
import '../../../repository/auth_repo.dart';

part 'social_login_event.dart';
part 'social_login_state.dart';

class SocialLoginBloc extends Bloc<SocialLoginEvent, SocialLoginState> {

  final AuthRepo _authRepo;

  SocialLoginBloc({
    required this._authRepo,
  }) : super(SocialLoginInitial()) {
    on<UserSocialLoginEvent>(_onSocialLoginEvent);
  }

  Future<void> _onSocialLoginEvent(UserSocialLoginEvent event, Emitter<SocialLoginState> emit) async {
    emit(SocialLoginLoading());

    final response = await _authRepo.socialLogin(url: event.url, body: event.body);
    if (response.status) {
      emit(SocialLoginSuccess(model: response.data));
    } else {
      emit(SocialLoginFailed(message: response.message));
    }
  }
}
