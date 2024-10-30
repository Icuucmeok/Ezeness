import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ezeness/data/repositories/profile_repository.dart';
part 'subscribe_user_notification_state.dart';


class SubscribeUserNotificationCubit extends Cubit<SubscribeUserNotificationState> {
  final ProfileRepository _profileRepository;
  SubscribeUserNotificationCubit(this._profileRepository) : super(SubscribeUserNotificationInitial());


  void subscribeUnSubscribeUserNotification(int userId) async {
    emit(SubscribeUserNotificationLoading());
    try {
     final data =  await _profileRepository.subscribeUnSubscribeUserNotification(userId);
     emit(SubscribeUserNotificationDone(data!));
    } catch (e) {
      emit(SubscribeUserNotificationFailure(e));
    }
  }
}
