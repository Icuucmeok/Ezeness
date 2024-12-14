part of 'explore_home_cubit.dart';


abstract class ExploreHomeState extends Equatable {
  const ExploreHomeState();

  @override
  List<Object> get props => [];
}

class ExploreHomeInitial extends ExploreHomeState {}

class ExploreHomeLoading extends ExploreHomeState {}

class ExploreHomeFailure extends ExploreHomeState {
  final Object exception;

  const ExploreHomeFailure(this.exception);
    @override
  List<Object> get props => [exception];
}

class ExploreHomeLoaded extends ExploreHomeState {
  final ExploreResponse response;

  const ExploreHomeLoaded(this.response);
  @override
  List<Object> get props => [response];

}
