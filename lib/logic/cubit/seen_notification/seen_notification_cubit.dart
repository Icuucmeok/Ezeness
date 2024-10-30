import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/repositories/Notification_repository.dart';
part 'seen_notification_state.dart';


class SeenNotificationCubit extends Cubit<SeenNotificationState> {
  final NotificationRepository _notificationRepository;

  SeenNotificationCubit(this._notificationRepository) : super(SeenNotificationInitial());

  void setNotificationSeen(int? id) async {
    /// id null mean set all notification as read
    emit(SeenNotificationLoading());
    try {
      final data =  await _notificationRepository.setNotificationSeen(id);
      emit(SeenNotificationDone(data!));
    } catch (e) {
      emit(SeenNotificationFailure(e));
    }
  }
}
