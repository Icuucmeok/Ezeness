part of 'add_post_boost_cubit.dart';

class AddPostBoostState extends Equatable {
  const AddPostBoostState();

  @override
  List<Object> get props => [];
}

class AddPostBoostInitial extends AddPostBoostState {}

class AddPostBoostLoading extends AddPostBoostState {}

class AddPostBoostFailure extends AddPostBoostState {
  final Object exception;

  const AddPostBoostFailure(this.exception);
  @override
  List<Object> get props => [exception];
}

class AddPostBoostDone extends AddPostBoostState {
  const AddPostBoostDone();
}
