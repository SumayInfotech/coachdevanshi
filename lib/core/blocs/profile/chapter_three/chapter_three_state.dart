part of 'chapter_three_bloc.dart';

sealed class ChapterThreeState extends Equatable {
  const ChapterThreeState();
}

final class ChapterThreeInitial extends ChapterThreeState {
  @override
  List<Object> get props => [];
}

final class ChapterThreeLoading extends ChapterThreeState {
  @override
  List<Object> get props => [];
}

final class ChapterThreeSuccess extends ChapterThreeState {
  final ChapterThreeModel model;

  const new({required this.model});

  @override
  List<Object> get props => [model];
}

final class ChapterThreeFailed extends ChapterThreeState {
  final String message;

  const new({required this.message});

  @override
  List<Object> get props => [message];
}
