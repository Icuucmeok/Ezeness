part of 'explore_kids_cubit.dart';


abstract class ExploreKidsState extends Equatable {
  const ExploreKidsState();

  @override
  List<Object> get props => [];
}

class ExploreKidsInitial extends ExploreKidsState {}


class ExploreKidsLoading extends ExploreKidsState {}

class ExploreKidsFailure extends ExploreKidsState {
  final Object exception;

  const ExploreKidsFailure(this.exception);
  @override
  List<Object> get props => [exception];
}

class ExploreKidsLoaded extends ExploreKidsState {
  final ExploreResponse response;

  const ExploreKidsLoaded(this.response);
  @override
  List<Object> get props => [response];

}
