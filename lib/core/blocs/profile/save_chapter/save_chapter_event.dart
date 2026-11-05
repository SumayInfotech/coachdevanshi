part of 'save_chapter_bloc.dart';

sealed class SaveChapterEvent extends Equatable {
  const SaveChapterEvent();
}

class UserSaveChapterEvent extends SaveChapterEvent {

  final String url;
  final Map<String, dynamic> body;

  const new({required this.url, required this.body});

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
