import 'package:equatable/equatable.dart';

sealed class UploadBloodReportEvent extends Equatable {
  const UploadBloodReportEvent();

  @override
  List<Object?> get props => [];
}

class UserUploadBloodReportEvent extends UploadBloodReportEvent {
  final String url;
  final Map<String, dynamic> body;

  const UserUploadBloodReportEvent({
    required this.url,
    required this.body,
  });

  @override
  List<Object?> get props => [url, body];
}
