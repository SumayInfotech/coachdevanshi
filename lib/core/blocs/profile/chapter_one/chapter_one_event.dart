part of 'chapter_one_bloc.dart';

sealed class ChapterOneEvent extends Equatable {
  const ChapterOneEvent();
}

class UserChapterOneEvent extends ChapterOneEvent {

  final String url;

  const new({required this.url});

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
