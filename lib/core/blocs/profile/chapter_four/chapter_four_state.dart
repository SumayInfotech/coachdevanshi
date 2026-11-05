part of 'chapter_four_bloc.dart';

sealed class ChapterFourState extends Equatable {
  const ChapterFourState();
}

final class ChapterFourInitial extends ChapterFourState {
  @override
  List<Object> get props => [];
}

final class ChapterFourLoading extends ChapterFourState {
  @override
  List<Object> get props => [];
}

final class ChapterFourSuccess extends ChapterFourState {
  final ChapterFourModel model;

  const ChapterFourSuccess({required this.model});

  @override
  List<Object> get props => [model];
}

final class ChapterFourFailed extends ChapterFourState {
  final String message;

  const ChapterFourFailed({required this.message});

  @override
  List<Object> get props => [message];
}
