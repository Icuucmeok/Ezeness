part of 'subscribe_user_notification_cubit.dart';


abstract class SubscribeUserNotificationState extends Equatable {
  const SubscribeUserNotificationState();

  @override
  List<Object> get props => [];
}

class SubscribeUserNotificationInitial extends SubscribeUserNotificationState {}

class SubscribeUserNotificationLoading extends SubscribeUserNotificationState {}
class SubscribeUserNotificationFailure extends SubscribeUserNotificationState {
  final Object exception;

  const SubscribeUserNotificationFailure(this.exception);
    @override
  List<Object> get props => [exception];
}
class SubscribeUserNotificationDone extends SubscribeUserNotificationState {
  final String response;

  const SubscribeUserNotificationDone(this.response);
  @override
  List<Object> get props => [response];

}




