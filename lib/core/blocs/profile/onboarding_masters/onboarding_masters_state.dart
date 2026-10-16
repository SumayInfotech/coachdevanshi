part of 'onboarding_masters_bloc.dart';

sealed class OnboardingMastersState extends Equatable {
  const OnboardingMastersState();
}

final class OnboardingMastersInitial extends OnboardingMastersState {
  @override
  List<Object> get props => [];
}

final class OnboardingMastersLoading extends OnboardingMastersState {
  @override
  List<Object> get props => [];
}

final class OnboardingMastersSuccess extends OnboardingMastersState {
  final OnboardingMastersModel model;

  const new({required this.model});

  @override
  List<Object> get props => [];
}

final class OnboardingMastersFailed extends OnboardingMastersState {
  final String message;

  const new({required this.message});

  @override
  List<Object> get props => [];
}
