part of 'chapter_five_bloc.dart';

sealed class ChapterFiveState extends Equatable {
  const ChapterFiveState();
}

final class ChapterFiveInitial extends ChapterFiveState {
  @override
  List<Object> get props => [];
}

final class ChapterFiveLoading extends ChapterFiveState {
  @override
  List<Object> get props => [];
}

final class ChapterFiveSuccess extends ChapterFiveState {
  final ChapterFiveModel model;

  const ChapterFiveSuccess({required this.model});

  @override
  List<Object> get props => [model];
}

final class ChapterFiveFailed extends ChapterFiveState {
  final String message;

  const ChapterFiveFailed({required this.message});

  @override
  List<Object> get props => [message];
}
