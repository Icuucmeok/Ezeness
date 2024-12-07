part of 'my_favourite_cubit.dart';



abstract class MyFavouriteState extends Equatable {
  const MyFavouriteState();

  @override
  List<Object> get props => [];
}

class MyFavouriteInitial extends MyFavouriteState {}



class MyFavouriteListLoading extends MyFavouriteState {}
class MyFavouriteListFailure extends MyFavouriteState {
  final Object exception;

  const MyFavouriteListFailure(this.exception);
  @override
  List<Object> get props => [exception];
}
class MyFavouriteListLoaded extends MyFavouriteState {
  final MyFavouriteResponse response;

  const MyFavouriteListLoaded(this.response);
  @override
  List<Object> get props => [response];

}
