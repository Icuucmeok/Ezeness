part of 'liftup_post_cubit.dart';


abstract class LiftUpPostState extends Equatable {
  const LiftUpPostState();

  @override
  List<Object> get props => [];
}

class LiftUpPostInitial extends LiftUpPostState {}

class LiftUpPostLoading extends LiftUpPostState {}
class LiftUpPostFailure extends LiftUpPostState {
  final Object exception;

  const LiftUpPostFailure(this.exception);
    @override
  List<Object> get props => [exception];
}
class LiftUpPostDone extends LiftUpPostState {
  final String response;

  const LiftUpPostDone(this.response);
  @override
  List<Object> get props => [response];

}


class LiftUpPostUserListLoading extends LiftUpPostState {}
class LiftUpPostUserListFailure extends LiftUpPostState {
  final Object exception;

  const LiftUpPostUserListFailure(this.exception);
  @override
  List<Object> get props => [exception];
}
class LiftUpPostUserListDone extends LiftUpPostState {
  final LiftUpUserList response;

  const LiftUpPostUserListDone(this.response);
  @override
  List<Object> get props => [response];

}

