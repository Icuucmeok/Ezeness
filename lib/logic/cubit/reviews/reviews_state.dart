part of 'reviews_cubit.dart';


abstract class ReviewsState extends Equatable {
  const ReviewsState();

  @override
  List<Object> get props => [];
}

class ReviewsInitial extends ReviewsState {}

class ReviewsLoading extends ReviewsState {}
class ReviewsFailure extends ReviewsState {
  final Object exception;

  const ReviewsFailure(this.exception);
    @override
  List<Object> get props => [exception];
}
class ReviewsAdded extends ReviewsState {
  final ReviewModel response;

  const ReviewsAdded(this.response);
  @override
  List<Object> get props => [response];

}
class ReviewsDeleted extends ReviewsState {
  final String response;

  const ReviewsDeleted(this.response);
  @override
  List<Object> get props => [response];

}




