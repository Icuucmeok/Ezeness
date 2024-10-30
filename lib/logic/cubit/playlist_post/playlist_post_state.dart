part of 'playlist_post_cubit.dart';



abstract class PlaylistPostState extends Equatable {
  const PlaylistPostState();

  @override
  List<Object> get props => [];
}

class PlaylistPostInitial extends PlaylistPostState {}



class PlaylistPostListLoading extends PlaylistPostState {}
class PlaylistPostListFailure extends PlaylistPostState {
  final Object exception;

  const PlaylistPostListFailure(this.exception);
  @override
  List<Object> get props => [exception];
}
class PlaylistPostListLoaded extends PlaylistPostState {
  final PostList response;

  const PlaylistPostListLoaded(this.response);
  @override
  List<Object> get props => [response];

}
