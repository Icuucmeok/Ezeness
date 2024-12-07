part of 'blocked_users_cubit.dart';


abstract class BlockedUsersState extends Equatable {
  const BlockedUsersState();

  @override
  List<Object> get props => [];
}

class BlockedUsersInitial extends BlockedUsersState {}

class BlockedUsersLoading extends BlockedUsersState {}
class BlockedUsersFailure extends BlockedUsersState {
  final Object exception;

  const BlockedUsersFailure(this.exception);
    @override
  List<Object> get props => [exception];
}
class BlockedUsersLoaded extends BlockedUsersState {
  final BlockedUserList response;

  const BlockedUsersLoaded(this.response);
  @override
  List<Object> get props => [response];

}










