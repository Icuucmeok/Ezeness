import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/models/post/post_list.dart';
import '../../../data/repositories/post_repository.dart';


part 'category_post_state.dart';

class CategoryPostCubit extends Cubit<CategoryPostState> {
  final PostRepository _postRepository;
  CategoryPostCubit(this._postRepository) : super(CategoryPostInitial());

  void getPostsByCategoryId({required int id,required bool isMine,required int? userId,int? postType,required int isForKids,int? isVip}) async {
    emit(CategoryPostListLoading());
    try {
      final data =  await _postRepository.getPostsByCategoryId(id,isMine,userId: userId,postType: postType,isForKids: isForKids,isVip: isVip);
      emit(CategoryPostListLoaded(data!));
    } catch (e) {
      emit(CategoryPostListFailure(e));
    }
  }
}
