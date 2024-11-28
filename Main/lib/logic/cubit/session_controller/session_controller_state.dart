part of 'session_controller_cubit.dart';

@immutable
abstract class SessionControllerState extends Equatable {
  final GlobalKey? globalKey;
  const SessionControllerState({this.globalKey});

  @override
  List<Object> get props => [];
}

class SessionControllerInitial extends SessionControllerState {
  SessionControllerInitial() : super(globalKey: GlobalKey());
}

class SessionControllerLoading extends SessionControllerState {}

class SessionControllerError extends SessionControllerState {
  final Object exception;

  const SessionControllerError(this.exception);
    @override
  List<Object> get props => [exception];
}

class SessionControllerSignedOut extends SessionControllerState {
  SessionControllerSignedOut() : super(globalKey: GlobalKey());
}
class SessionControllerGoToSigInScreen extends SessionControllerState {
  SessionControllerGoToSigInScreen() : super(globalKey: GlobalKey());
}
class SessionControllerSignedIn extends SessionControllerState {
  final LoginResponse response;

  const SessionControllerSignedIn(this.response);
  @override
  List<Object> get props => [response];

}

class SessionControllerSocialSignedIn extends SessionControllerState {
  final LoginResponse response;

  const SessionControllerSocialSignedIn(this.response);
  @override
  List<Object> get props => [response];

}

class SessionControllerSignedUp extends SessionControllerState {
  final LoginResponse response;

  const SessionControllerSignedUp(this.response);
  @override
  List<Object> get props => [response];

}

class SessionControllerVerificationSent extends SessionControllerState {
  const SessionControllerVerificationSent();
}
class SessionControllerVerificationReSent extends SessionControllerState {
  const SessionControllerVerificationReSent();
}


class SessionControllerInvitationCodeChecked extends SessionControllerState {
  const SessionControllerInvitationCodeChecked();
}

class SessionControllerCodeVerified extends SessionControllerState {
  const SessionControllerCodeVerified();
}

class SessionControllerResetPasswordCodeSent extends SessionControllerState {
  const SessionControllerResetPasswordCodeSent();
}
class SessionControllerResetPasswordCodeReSent extends SessionControllerState {
  const SessionControllerResetPasswordCodeReSent();
}
class SessionControllerResetPasswordCodeChecked extends SessionControllerState {
  const SessionControllerResetPasswordCodeChecked();
}

class SessionControllerResetPasswordDone extends SessionControllerState {
  const SessionControllerResetPasswordDone();
}

class SessionControllerCreateChangePasswordDone extends SessionControllerState {
  const SessionControllerCreateChangePasswordDone();
}

class SessionControllerDeleteAccountDone extends SessionControllerState {
  const SessionControllerDeleteAccountDone();
}

class SessionControllerSignUpInfoValidateDone extends SessionControllerState {
  const SessionControllerSignUpInfoValidateDone();
}

class SessionControllerInvitationLoading extends SessionControllerState {
  const SessionControllerInvitationLoading();
}
class SessionControllerInvitationSent extends SessionControllerState {
  const SessionControllerInvitationSent();
}
class SessionControllerInvitationError extends SessionControllerState {
  final Object exception;

  const SessionControllerInvitationError(this.exception);
  @override
  List<Object> get props => [exception];
}

class SessionControllerSignedUpNextPage extends SessionControllerState {
  const SessionControllerSignedUpNextPage();
}

class SessionControllerSignedUpPreviousPage extends SessionControllerState {
  const SessionControllerSignedUpPreviousPage();
}
class SessionControllerUserNameSuggestionLoading extends SessionControllerState {}

class SessionControllerUserNameSuggestionLoaded extends SessionControllerState {
  final List<String> response;

  const SessionControllerUserNameSuggestionLoaded(this.response);

  @override
  List<Object> get props => [response];

}