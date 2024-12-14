part of 'delete_post_cubit.dart';


abstract class DeletePostState extends Equatable {
  const DeletePostState();

  @override
  List<Object> get props => [];
}

class DeletePostInitial extends DeletePostState {}

class DeletePostLoading extends DeletePostState {}
class DeletePostFailure extends DeletePostState {
  final Object exception;

  const DeletePostFailure(this.exception);
    @override
  List<Object> get props => [exception];
}
class DeletePostDone extends DeletePostState {
  final String response;

  const DeletePostDone(this.response);
  @override
  List<Object> get props => [response];

}




