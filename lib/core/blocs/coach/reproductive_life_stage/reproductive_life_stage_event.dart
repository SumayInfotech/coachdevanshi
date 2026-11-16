import 'package:equatable/equatable.dart';

sealed class ReproductiveLifeStageEvent extends Equatable {
  const ReproductiveLifeStageEvent();

  @override
  List<Object?> get props => [];
}

class UserGetReproductiveLifeStageEvent extends ReproductiveLifeStageEvent {
  final String url;

  const UserGetReproductiveLifeStageEvent({required this.url});

  @override
  List<Object?> get props => [url];
}
