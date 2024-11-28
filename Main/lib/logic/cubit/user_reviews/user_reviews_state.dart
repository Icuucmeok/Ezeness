part of 'user_reviews_cubit.dart';


abstract class UserReviewsState extends Equatable {
  const UserReviewsState();

  @override
  List<Object> get props => [];
}

class UserReviewsInitial extends UserReviewsState {}

class UserReviewsLoading extends UserReviewsState {}
class UserReviewsFailure extends UserReviewsState {
  final Object exception;

  const UserReviewsFailure(this.exception);
    @override
  List<Object> get props => [exception];
}
class UserReviewsLoaded extends UserReviewsState {
  final ReviewList response;

  const UserReviewsLoaded(this.response);
  @override
  List<Object> get props => [response];

}




