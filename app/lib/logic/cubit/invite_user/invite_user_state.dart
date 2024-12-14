part of 'invite_user_cubit.dart';


abstract class InviteUserState extends Equatable {
  const InviteUserState();

  @override
  List<Object> get props => [];
}

class InviteUserInitial extends InviteUserState {}

class InviteUserLoading extends InviteUserState {}
class InviteUserFailure extends InviteUserState {
  final Object exception;

  const InviteUserFailure(this.exception);
    @override
  List<Object> get props => [exception];
}
class InvitationLoaded extends InviteUserState {
  final InviteUserList response;

  const InvitationLoaded(this.response);
  @override
  List<Object> get props => [response];

}

class InvitationCreditLoaded extends InviteUserState {
  final InviteCreditList response;

  const InvitationCreditLoaded(this.response);
  @override
  List<Object> get props => [response];

}

class InviteUserDone extends InviteUserState {
  final String response;

  const InviteUserDone(this.response);
  @override
  List<Object> get props => [response];

}

class DeleteInviteDone extends InviteUserState {
  final String response;

  const DeleteInviteDone(this.response);
  @override
  List<Object> get props => [response];

}









