part of 'profile_cubit.dart';


abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileFailure extends ProfileState {
  final Object exception;

  const ProfileFailure(this.exception);
    @override
  List<Object> get props => [exception];
}

class ProfileLoaded extends ProfileState {
  final User response;

  const ProfileLoaded(this.response);
  @override
  List<Object> get props => [response];

}

class ProfileListLoaded extends ProfileState {
  final UserList response;

  const ProfileListLoaded(this.response);
  @override
  List<Object> get props => [response];

}



class EditProfileLoading extends ProfileState {}

class EditProfileFailure extends ProfileState {
  final Object exception;

  const EditProfileFailure(this.exception);
  @override
  List<Object> get props => [exception];
}

class EditProfileDone extends ProfileState {
  final String response;

  const EditProfileDone(this.response);
  @override
  List<Object> get props => [response];

}
