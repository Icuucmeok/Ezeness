part of 'explore_users_cubit.dart';



abstract class ExploreUsersState extends Equatable {
  const ExploreUsersState();

  @override
  List<Object> get props => [];
}

class ExploreUsersInitial extends ExploreUsersState {}



class ExploreUsersListLoading extends ExploreUsersState {}
class ExploreUsersListFailure extends ExploreUsersState {
  final Object exception;

  const ExploreUsersListFailure(this.exception);
  @override
  List<Object> get props => [exception];
}
class ExploreUsersListLoaded extends ExploreUsersState {
  final UserList response;

  const ExploreUsersListLoaded(this.response);
  @override
  List<Object> get props => [response];

}
