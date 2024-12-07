part of 'notification_by_type_cubit.dart';

abstract class NotificationByTypeState extends Equatable {
  const NotificationByTypeState();

  @override
  List<Object> get props => [];
}

class NotificationByTypeInitial extends NotificationByTypeState {}

class NotificationByTypeLoading extends NotificationByTypeState {}

class NotificationByTypeFailure extends NotificationByTypeState {
  final Object exception;

  const NotificationByTypeFailure(this.exception);
  @override
  List<Object> get props => [exception];
}

class NotificationByTypeLoaded extends NotificationByTypeState {
  final NotificationList response;

  const NotificationByTypeLoaded(this.response);
  @override
  List<Object> get props => [response];
}
