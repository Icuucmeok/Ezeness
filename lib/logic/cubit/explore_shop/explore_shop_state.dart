part of 'explore_shop_cubit.dart';


abstract class ExploreShopState extends Equatable {
  const ExploreShopState();

  @override
  List<Object> get props => [];
}

class ExploreShopInitial extends ExploreShopState {}

class ExploreShopLoading extends ExploreShopState {}

class ExploreShopFailure extends ExploreShopState {
  final Object exception;

  const ExploreShopFailure(this.exception);
  @override
  List<Object> get props => [exception];
}

class ExploreShopLoaded extends ExploreShopState {
  final ExploreResponse response;

  const ExploreShopLoaded(this.response);
  @override
  List<Object> get props => [response];

}
