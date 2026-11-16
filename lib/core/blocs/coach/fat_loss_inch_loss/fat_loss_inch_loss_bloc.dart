import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../repository/coach_repo.dart';
import 'fat_loss_inch_loss_event.dart';
import 'fat_loss_inch_loss_state.dart';

class FatLossInchLossBloc extends Bloc<FatLossInchLossEvent, FatLossInchLossState> {
  final CoachRepo coachRepo;

  FatLossInchLossBloc({
    required this.coachRepo,
  }) : super(FatLossInchLossInitial()) {
    on<UserGetFatLossInchLossEvent>(_onGetFatLossInchLossEvent);
  }

  Future<void> _onGetFatLossInchLossEvent(
    UserGetFatLossInchLossEvent event,
    Emitter<FatLossInchLossState> emit,
  ) async {
    emit(FatLossInchLossLoading());

    final response = await coachRepo.getFatLossInchLoss(url: event.url);

    if (response.status && response.data != null) {
      emit(FatLossInchLossSuccess(model: response.data!));
    } else {
      emit(FatLossInchLossFailed(message: response.message));
    }
  }
}
