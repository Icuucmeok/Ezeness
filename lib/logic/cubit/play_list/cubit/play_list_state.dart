part of 'play_list_cubit.dart';


abstract class PlayListState extends Equatable {
  const PlayListState();

  @override
  List<Object> get props => [];
}

class PlaylistInitial extends PlayListState {}

class PlaylistLoading extends PlayListState {}
class PlaylistFailure extends PlayListState {
  final Object exception;

  const PlaylistFailure(this.exception);
  @override
  List<Object> get props => [exception];
}
class PlaylistAdded extends PlayListState {
  final Playlist response;

  const PlaylistAdded(this.response);
  @override
  List<Object> get props => [response];

}

class PlaylistPostAddedRemoved extends PlayListState {
  final String response;

  const PlaylistPostAddedRemoved(this.response);
  @override
  List<Object> get props => [response];

}