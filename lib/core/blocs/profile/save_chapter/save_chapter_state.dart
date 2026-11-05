part of 'save_chapter_bloc.dart';

sealed class SaveChapterState extends Equatable {
  const SaveChapterState();
}

final class SaveChapterInitial extends SaveChapterState {
  @override
  List<Object> get props => [];
}

final class SaveChapterLoading extends SaveChapterState {
  @override
  List<Object> get props => [];
}

final class SaveChapterSuccess extends SaveChapterState {
  final CommonModel model;

  const new({required this.model});

  @override
  List<Object> get props => [];
}

final class SaveChapterFailed extends SaveChapterState {
  final String message;

  const new({required this.message});

  @override
  List<Object> get props => [];
}
