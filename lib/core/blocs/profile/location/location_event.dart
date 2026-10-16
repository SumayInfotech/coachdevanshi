part of 'location_bloc.dart';

sealed class LocationEvent extends Equatable {
  const LocationEvent();
}

class UserLocationEvent extends LocationEvent {

  final String url;
  final Map<String, dynamic> body;

  const new({required this.url, required this.body});

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
