part of 'chapter_six_bloc.dart';

sealed class ChapterSixState extends Equatable {
  const ChapterSixState();
}

final class ChapterSixInitial extends ChapterSixState {
  @override
  List<Object> get props => [];
}

final class ChapterSixLoading extends ChapterSixState {
  @override
  List<Object> get props => [];
}

final class ChapterSixSuccess extends ChapterSixState {
  final ChapterSixModel model;

  const ChapterSixSuccess({required this.model});

  @override
  List<Object> get props => [model];
}

final class ChapterSixFailed extends ChapterSixState {
  final String message;

  const ChapterSixFailed({required this.message});

  @override
  List<Object> get props => [message];
}
