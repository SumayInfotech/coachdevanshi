part of 'chapter_six_bloc.dart';

sealed class ChapterSixEvent extends Equatable {
  const ChapterSixEvent();
}

class UserChapterSixEvent extends ChapterSixEvent {
  final String url;

  const UserChapterSixEvent({required this.url});

  @override
  List<Object?> get props => [url];
}
