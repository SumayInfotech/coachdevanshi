part of 'chapter_four_bloc.dart';

sealed class ChapterFourEvent extends Equatable {
  const ChapterFourEvent();
}

class UserChapterFourEvent extends ChapterFourEvent {
  final String url;

  const UserChapterFourEvent({required this.url});

  @override
  List<Object?> get props => [url];
}
