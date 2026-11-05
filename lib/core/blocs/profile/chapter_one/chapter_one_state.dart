part of 'chapter_one_bloc.dart';

sealed class ChapterOneState extends Equatable {
  const ChapterOneState();
}

final class ChapterOneInitial extends ChapterOneState {
  @override
  List<Object> get props => [];
}

final class ChapterOneLoading extends ChapterOneState {
  @override
  List<Object> get props => [];
}

final class ChapterOneSuccess extends ChapterOneState {
  final ChapterOneModel model;

  const new({required this.model});

  @override
  List<Object> get props => [];
}

final class ChapterOneFailed extends ChapterOneState {
  final String message;

  const new({required this.message});

  @override
  List<Object> get props => [];
}
