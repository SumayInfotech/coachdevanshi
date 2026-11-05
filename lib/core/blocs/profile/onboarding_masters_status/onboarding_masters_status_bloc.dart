import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../models/profile/onboarding_master_status_model.dart';
import '../../../repository/profile_repo.dart';

part 'onboarding_masters_status_event.dart';
part 'onboarding_masters_status_state.dart';

class OnboardingMasterStatusBloc extends Bloc<OnboardingMasterStatusEvent, OnboardingMasterStatusState> {

  final ProfileRepo _profileRepo;

  OnboardingMasterStatusBloc({
    required this._profileRepo,
  }) : super(OnboardingMasterStatusInitial()) {
    on<UserOnboardingMasterStatusEvent>(_onOnboardingMasterStatusEvent);
  }

  Future<void> _onOnboardingMasterStatusEvent(UserOnboardingMasterStatusEvent event, Emitter<OnboardingMasterStatusState> emit) async {
    emit(OnboardingMasterStatusLoading());

    final response = await _profileRepo.onboardingMastersStatus(url: event.url);
    if (response.status) {
      emit(OnboardingMasterStatusSuccess(model: response.data));
    } else {
      emit(OnboardingMasterStatusFailed(message: response.message));
    }
  }
}
