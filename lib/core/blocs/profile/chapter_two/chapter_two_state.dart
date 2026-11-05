part of 'chapter_two_bloc.dart';

sealed class ChapterTwoState extends Equatable {
  const ChapterTwoState();
}

final class ChapterTwoInitial extends ChapterTwoState {
  @override
  List<Object> get props => [];
}

final class ChapterTwoLoading extends ChapterTwoState {
  @override
  List<Object> get props => [];
}

final class ChapterTwoSuccess extends ChapterTwoState {
  final ChapterTwoModel model;

  const new({required this.model});

  @override
  List<Object> get props => [];
}

final class ChapterTwoFailed extends ChapterTwoState {
  final String message;

  const new({required this.message});

  @override
  List<Object> get props => [];
}
