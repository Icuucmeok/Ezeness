part of 'discover_post_cubit.dart';



abstract class DiscoverPostState extends Equatable {
  const DiscoverPostState();

  @override
  List<Object> get props => [];
}

class DiscoverPostInitial extends DiscoverPostState {}



class DiscoverHomeListLoading extends DiscoverPostState {}
class DiscoverHomeListFailure extends DiscoverPostState {
  final Object exception;

  const DiscoverHomeListFailure(this.exception);
  @override
  List<Object> get props => [exception];
}
class DiscoverHomeListLoaded extends DiscoverPostState {
  final PostList response;

  const DiscoverHomeListLoaded(this.response);
  @override
  List<Object> get props => [response];

}


class DiscoverShopListLoading extends DiscoverPostState {}
class DiscoverShopListFailure extends DiscoverPostState {
  final Object exception;

  const DiscoverShopListFailure(this.exception);
  @override
  List<Object> get props => [exception];
}
class DiscoverShopListLoaded extends DiscoverPostState {
  final PostList response;

  const DiscoverShopListLoaded(this.response);
  @override
  List<Object> get props => [response];

}

class DiscoverSocialListLoading extends DiscoverPostState {}
class DiscoverSocialListFailure extends DiscoverPostState {
  final Object exception;

  const DiscoverSocialListFailure(this.exception);
  @override
  List<Object> get props => [exception];
}
class DiscoverSocialListLoaded extends DiscoverPostState {
  final PostList response;

  const DiscoverSocialListLoaded(this.response);
  @override
  List<Object> get props => [response];

}

class DiscoverKidsListLoading extends DiscoverPostState {}
class DiscoverKidsListFailure extends DiscoverPostState {
  final Object exception;

  const DiscoverKidsListFailure(this.exception);
  @override
  List<Object> get props => [exception];
}
class DiscoverKidsListLoaded extends DiscoverPostState {
  final PostList response;

  const DiscoverKidsListLoaded(this.response);
  @override
  List<Object> get props => [response];

}