part of 'chapter_five_bloc.dart';

sealed class ChapterFiveEvent extends Equatable {
  const ChapterFiveEvent();
}

class UserChapterFiveEvent extends ChapterFiveEvent {
  final String url;

  const UserChapterFiveEvent({required this.url});

  @override
  List<Object?> get props => [url];
}
