part of 'search_cubit.dart';


abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchFailure extends SearchState {
  final Object exception;

  const SearchFailure(this.exception);
    @override
  List<Object> get props => [exception];
}




class SearchResponseLoaded extends SearchState {
  final SearchResponse response;

  const SearchResponseLoaded(this.response);
  @override
  List<Object> get props => [response];

}
