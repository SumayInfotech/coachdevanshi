import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../models/home/daily_checkin_model.dart';
import '../../../repository/home_repo.dart';

part 'daily_checkin_event.dart';
part 'daily_checkin_state.dart';

class DailyCheckinBloc extends Bloc<DailyCheckinEvent, DailyCheckinState> {
  final HomeRepo homeRepo;

  DailyCheckinBloc({
    required this.homeRepo,
  }) : super(DailyCheckinInitial()) {
    on<UserDailyCheckinEvent>(_onDailyCheckinEvent);
  }

  Future<void> _onDailyCheckinEvent(
    UserDailyCheckinEvent event,
    Emitter<DailyCheckinState> emit,
  ) async {
    emit(DailyCheckinLoading());

    final response = await homeRepo.getDailyCheckin(url: event.url);
    if (response.status) {
      emit(DailyCheckinSuccess(model: response.data));
    } else {
      emit(DailyCheckinFailed(message: response.message));
    }
  }
}
