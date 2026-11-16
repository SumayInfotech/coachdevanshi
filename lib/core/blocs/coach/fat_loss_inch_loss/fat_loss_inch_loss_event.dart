import 'package:equatable/equatable.dart';

sealed class FatLossInchLossEvent extends Equatable {
  const FatLossInchLossEvent();

  @override
  List<Object?> get props => [];
}

class UserGetFatLossInchLossEvent extends FatLossInchLossEvent {
  final String url;

  const UserGetFatLossInchLossEvent({required this.url});

  @override
  List<Object?> get props => [url];
}
