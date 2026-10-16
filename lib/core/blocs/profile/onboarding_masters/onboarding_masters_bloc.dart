import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../models/profile/onboarding_masters_model.dart';
import '../../../repository/profile_repo.dart';

part 'onboarding_masters_event.dart';
part 'onboarding_masters_state.dart';

class OnboardingMastersBloc extends Bloc<OnboardingMastersEvent, OnboardingMastersState> {

  final ProfileRepo _profileRepo;

  OnboardingMastersBloc({
    required this._profileRepo,
  }) : super(OnboardingMastersInitial()) {
    on<UserOnboardingMastersEvent>(_onOnboardingMastersEvent);
  }

  Future<void> _onOnboardingMastersEvent(UserOnboardingMastersEvent event, Emitter<OnboardingMastersState> emit) async {
    emit(OnboardingMastersLoading());

    final response = await _profileRepo.onboardingMasters(url: event.url);
    if (response.status) {
      emit(OnboardingMastersSuccess(model: response.data));
    } else {
      emit(OnboardingMastersFailed(message: response.message));
    }
  }
}
