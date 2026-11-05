part of 'onboarding_masters_status_bloc.dart';

sealed class OnboardingMasterStatusState extends Equatable {
  const OnboardingMasterStatusState();
}

final class OnboardingMasterStatusInitial extends OnboardingMasterStatusState {
  @override
  List<Object> get props => [];
}

final class OnboardingMasterStatusLoading extends OnboardingMasterStatusState {
  @override
  List<Object> get props => [];
}

final class OnboardingMasterStatusSuccess extends OnboardingMasterStatusState {
  final OnboardingMasterStatusModel model;

  const new({required this.model});

  @override
  List<Object> get props => [];
}

final class OnboardingMasterStatusFailed extends OnboardingMasterStatusState {
  final String message;

  const new({required this.message});

  @override
  List<Object> get props => [];
}
