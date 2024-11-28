part of 'explore_social_cubit.dart';


abstract class ExploreSocialState extends Equatable {
  const ExploreSocialState();

  @override
  List<Object> get props => [];
}

class ExploreSocialInitial extends ExploreSocialState {}

class ExploreSocialLoading extends ExploreSocialState {}

class ExploreSocialFailure extends ExploreSocialState {
  final Object exception;

  const ExploreSocialFailure(this.exception);
  @override
  List<Object> get props => [exception];
}

class ExploreSocialLoaded extends ExploreSocialState {
  final ExploreResponse response;

  const ExploreSocialLoaded(this.response);
  @override
  List<Object> get props => [response];

}


