part of 'pro_invitations_cubit.dart';

abstract class ProInvitationsState extends Equatable {
  const ProInvitationsState();

  @override
  List<Object> get props => [];
}

class ProInvitationsInitial extends ProInvitationsState {}

class ProInvitationsLoading extends ProInvitationsState {}

class ProInvitationsFailure extends ProInvitationsState {
  final Object exception;

  const ProInvitationsFailure(this.exception);
  @override
  List<Object> get props => [exception];
}

class ProInvitationsLoaded extends ProInvitationsState {
  final InviteUserList response;

  const ProInvitationsLoaded(this.response);
  @override
  List<Object> get props => [response];
}

class SendProInvitationsDone extends ProInvitationsState {
  final String response;

  const SendProInvitationsDone(this.response);
  @override
  List<Object> get props => [response];
}

class ToggleProInvitationStatusDone extends ProInvitationsState {
  final String response;

  const ToggleProInvitationStatusDone(this.response);
  @override
  List<Object> get props => [response];
}
