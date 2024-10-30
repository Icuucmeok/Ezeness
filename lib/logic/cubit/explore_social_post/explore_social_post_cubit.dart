import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ezeness/res/app_res.dart';
import '../../../data/models/post/post_list.dart';
import '../../../data/repositories/post_repository.dart';


part 'explore_social_post_state.dart';

class ExploreSocialPostCubit extends Cubit<ExploreSocialPostState> {
  final PostRepository _postRepository;
  ExploreSocialPostCubit(this._postRepository) : super(ExploreSocialPostInitial());

  void getExploreSocialPostList() async {
    emit(ExploreSocialPostListLoading());
    try {
      final data =  await _postRepository.getExploreTabPostList(Constants.socialTabKey);
      emit(ExploreSocialPostListLoaded(data!));
    } catch (e) {
      emit(ExploreSocialPostListFailure(e));
    }
  }

}
