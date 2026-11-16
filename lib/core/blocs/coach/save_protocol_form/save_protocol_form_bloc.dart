import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../repository/coach_repo.dart';
import 'save_protocol_form_event.dart';
import 'save_protocol_form_state.dart';

class SaveProtocolFormBloc extends Bloc<SaveProtocolFormEvent, SaveProtocolFormState> {
  final CoachRepo coachRepo;

  SaveProtocolFormBloc({
    required this.coachRepo,
  }) : super(SaveProtocolFormInitial()) {
    on<UserSaveProtocolFormEvent>(_onSaveProtocolFormEvent);
  }

  Future<void> _onSaveProtocolFormEvent(
    UserSaveProtocolFormEvent event,
    Emitter<SaveProtocolFormState> emit,
  ) async {
    emit(SaveProtocolFormLoading());

    final response = await coachRepo.saveProtocolForm(url: event.url, body: event.body);
    if (response.status && response.data != null) {
      emit(SaveProtocolFormSuccess(model: response.data!));
    } else {
      emit(SaveProtocolFormFailed(message: response.message));
    }
  }
}
