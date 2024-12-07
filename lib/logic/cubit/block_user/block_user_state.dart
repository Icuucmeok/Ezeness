part of 'block_user_cubit.dart';


abstract class BlockUserState extends Equatable {
  const BlockUserState();

  @override
  List<Object> get props => [];
}

class BlockUserInitial extends BlockUserState {}

class BlockUserLoading extends BlockUserState {}
class BlockUserFailure extends BlockUserState {
  final Object exception;

  const BlockUserFailure(this.exception);
    @override
  List<Object> get props => [exception];
}
class BlockUserDone extends BlockUserState {
  final String response;

  const BlockUserDone(this.response);
  @override
  List<Object> get props => [response];

}




