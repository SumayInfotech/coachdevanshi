part of 'onboarding_masters_status_bloc.dart';

sealed class OnboardingMasterStatusEvent extends Equatable {
  const OnboardingMasterStatusEvent();
}

class UserOnboardingMasterStatusEvent extends OnboardingMasterStatusEvent {

  final String url;

  const new({required this.url});

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
