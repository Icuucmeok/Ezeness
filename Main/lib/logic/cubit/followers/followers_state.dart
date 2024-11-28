part of 'followers_cubit.dart';


abstract class FollowersState extends Equatable {
  const FollowersState();

  @override
  List<Object> get props => [];
}

class FollowersInitial extends FollowersState {}

class FollowersLoading extends FollowersState {}
class FollowersFailure extends FollowersState {
  final Object exception;

  const FollowersFailure(this.exception);
    @override
  List<Object> get props => [exception];
}
class FollowersLoaded extends FollowersState {
  final Followers response;

  const FollowersLoaded(this.response);
  @override
  List<Object> get props => [response];

}










