part of 'hashtag_cubit.dart';


abstract class HashtagState extends Equatable {
  const HashtagState();

  @override
  List<Object> get props => [];
}

class HashtagInitial extends HashtagState {}

class HashtagLoading extends HashtagState {}
class HashtagFailure extends HashtagState {
  final Object exception;

  const HashtagFailure(this.exception);
    @override
  List<Object> get props => [exception];
}
class HashtagLoaded extends HashtagState {
  final HashtagList response;

  const HashtagLoaded(this.response);
  @override
  List<Object> get props => [response];

}










