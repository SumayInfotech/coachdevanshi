part of 'chapter_three_bloc.dart';

sealed class ChapterThreeEvent extends Equatable {
  const ChapterThreeEvent();
}

class UserChapterThreeEvent extends ChapterThreeEvent {
  final String url;

  const new({required this.url});

  @override
  List<Object?> get props => [url];
}
