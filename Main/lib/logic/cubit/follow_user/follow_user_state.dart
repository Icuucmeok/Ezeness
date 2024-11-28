part of 'follow_user_cubit.dart';


abstract class FollowUserState extends Equatable {
  const FollowUserState();

  @override
  List<Object> get props => [];
}

class FollowUserInitial extends FollowUserState {}

class FollowUserLoading extends FollowUserState {}
class FollowUserFailure extends FollowUserState {
  final Object exception;

  const FollowUserFailure(this.exception);
    @override
  List<Object> get props => [exception];
}
class FollowUserDone extends FollowUserState {
  final String response;

  const FollowUserDone(this.response);
  @override
  List<Object> get props => [response];

}




