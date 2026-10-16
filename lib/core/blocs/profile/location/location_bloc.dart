import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../models/profile/location_model.dart';
import '../../../repository/profile_repo.dart';

part 'location_event.dart';
part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {

  final ProfileRepo _profileRepo;

  LocationBloc({
    required this._profileRepo,
  }) : super(LocationInitial()) {
    on<UserLocationEvent>(_onLocationEvent);
  }

  Future<void> _onLocationEvent(UserLocationEvent event, Emitter<LocationState> emit) async {
    emit(LocationLoading());

    final response = await _profileRepo.location(url: event.url, body: event.body);
    if (response.status) {
      emit(LocationSuccess(model: response.data));
    } else {
      emit(LocationFailed(message: response.message));
    }
  }
}
