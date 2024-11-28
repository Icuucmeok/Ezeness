import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/models/notification/notification_list.dart';
import '../../../data/repositories/Notification_repository.dart';
part 'notification_by_type_state.dart';

class NotificationByTypeCubit extends Cubit<NotificationByTypeState> {
  final NotificationRepository _notificationRepository;

  NotificationByTypeCubit(this._notificationRepository)
      : super(NotificationByTypeInitial());

  void getNotificationByType({int? type}) async {
    emit(NotificationByTypeLoading());
    try {
      final data = await _notificationRepository.getNotificationsByType(type: type);
      emit(NotificationByTypeLoaded(data!));
    } catch (e) {
      emit(NotificationByTypeFailure(e));
    }
  }
}
