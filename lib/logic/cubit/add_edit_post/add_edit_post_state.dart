part of 'add_edit_post_cubit.dart';


abstract class AddEditPostState extends Equatable {
  const AddEditPostState();

  @override
  List<Object> get props => [];
}

class AddEditPostInitial extends AddEditPostState {}

class AddEditPostLoading extends AddEditPostState {}
class AddEditPostFailure extends AddEditPostState {
  final Object exception;

  const AddEditPostFailure(this.exception);
  @override
  List<Object> get props => [exception];
}
class AddPostDone extends AddEditPostState {
  final String response;

  const AddPostDone(this.response);
  @override
  List<Object> get props => [response];

}

class EditPostDone extends AddEditPostState {
  final Post response;

  const EditPostDone(this.response);
  @override
  List<Object> get props => [response];

}


class ValidatePostDone extends AddEditPostState {

  const ValidatePostDone();

  @override
  List<Object> get props => [];
}


class ValidatePostFailure extends AddEditPostState {
  final Object exception;

  const ValidatePostFailure(this.exception);
  @override
  List<Object> get props => [exception];
}