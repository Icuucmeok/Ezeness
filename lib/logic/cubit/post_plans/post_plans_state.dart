part of 'post_plans_cubit.dart';

class PostPlansState extends Equatable {
  const PostPlansState();

  @override
  List<Object> get props => [];
}

class PostPlansInitial extends PostPlansState {}

class PostPlansLoading extends PostPlansState {}

class PostPlansFailure extends PostPlansState {
  final Object exception;

  const PostPlansFailure(this.exception);
  @override
  List<Object> get props => [exception];
}

class PostPlansDone extends PostPlansState {
  final BoostPlansList? PostsPlansList;
  const PostPlansDone(this.PostsPlansList);
}
