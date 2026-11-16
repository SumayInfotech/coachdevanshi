import 'package:equatable/equatable.dart';

sealed class HealthyWeightGainEvent extends Equatable {
  const HealthyWeightGainEvent();

  @override
  List<Object?> get props => [];
}

class UserGetHealthyWeightGainEvent extends HealthyWeightGainEvent {
  final String url;

  const UserGetHealthyWeightGainEvent({required this.url});

  @override
  List<Object?> get props => [url];
}
