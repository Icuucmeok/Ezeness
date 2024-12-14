import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ezeness/data/models/post/post.dart';
import 'package:ezeness/data/models/post/post_list.dart';
import '../../../data/repositories/post_repository.dart';

part 'post_state.dart';

class PostCubit extends Cubit<PostState> {
  final PostRepository _postRepository;
  PostCubit(this._postRepository) : super(PostInitial());

  void initial(){
    emit(PostInitial());
  }

  void emitPost(Post post) async {
    await Future.delayed(const Duration(microseconds: 500));
    emit(PostLoaded(post));
  }

  void getPost(int id,{int? liftUpId}) async {
    emit(PostLoading());
    try {
      final data =  await _postRepository.getPost(id,liftUpId: liftUpId);
      emit(PostLoaded(data!));
    } catch (e) {
      emit(PostFailure(e));
    }
  }

  void getPosts({int? postType,int isKids=0,String? search,int? hashtagId,int? postId,bool withIsKids=true,int withLiftUp=1}) async {
    emit(PostListLoading());
    try {
      final data =  await _postRepository.getPosts(postType:postType,isKids: isKids,search: search,postId: postId,hashtagId: hashtagId,withIsKids:withIsKids,withLiftUp: withLiftUp);
      emit(PostListLoaded(data!));
    } catch (e) {
      emit(PostListFailure(e));
    }
  }

  void increaseViews(int postId,{bool isFromDiscover=false}) async {
    _postRepository.increaseViews(postId,isFromDiscover: isFromDiscover);
  }

}
