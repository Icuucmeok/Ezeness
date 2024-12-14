part of 'seen_notification_cubit.dart';


abstract class SeenNotificationState extends Equatable {
  const SeenNotificationState();

  @override
  List<Object> get props => [];
}

class SeenNotificationInitial extends SeenNotificationState {}

class SeenNotificationLoading extends SeenNotificationState {}
class SeenNotificationFailure extends SeenNotificationState {
  final Object exception;

  const SeenNotificationFailure(this.exception);
    @override
  List<Object> get props => [exception];
}
class SeenNotificationDone extends SeenNotificationState {
  final String response;

  const SeenNotificationDone(this.response);
  @override
  List<Object> get props => [response];

}




