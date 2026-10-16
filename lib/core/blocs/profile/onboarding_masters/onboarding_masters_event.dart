part of 'onboarding_masters_bloc.dart';

sealed class OnboardingMastersEvent extends Equatable {
  const OnboardingMastersEvent();
}

class UserOnboardingMastersEvent extends OnboardingMastersEvent {

  final String url;

  const new({required this.url});

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
