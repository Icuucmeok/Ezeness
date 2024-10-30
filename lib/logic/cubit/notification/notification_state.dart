part of 'notification_cubit.dart';

class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object> get props => [];
}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationFailure extends NotificationState {
  final Object exception;

  const NotificationFailure(this.exception);
  @override
  List<Object> get props => [exception];
}

class NotificationLoaded extends NotificationState {
  final AllNotificationList response;

  const NotificationLoaded(this.response);
  @override
  List<Object> get props => [response];
}
