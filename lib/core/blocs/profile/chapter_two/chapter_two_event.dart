part of 'chapter_two_bloc.dart';

sealed class ChapterTwoEvent extends Equatable {
  const ChapterTwoEvent();
}

class UserChapterTwoEvent extends ChapterTwoEvent {

  final String url;

  const new({required this.url});

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
