import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/models/post/post_list.dart';
import '../../../data/repositories/post_repository.dart';
import '../../../res/app_res.dart';


part 'explore_shop_post_state.dart';

class ExploreShopPostCubit extends Cubit<ExploreShopPostState> {
  final PostRepository _postRepository;
  ExploreShopPostCubit(this._postRepository) : super(ExploreShopPostInitial());

  void getExploreShopPostList() async {
    emit(ExploreShopPostListLoading());
    try {
      final data =  await _postRepository.getExploreTabPostList(Constants.shopTabKey);
      emit(ExploreShopPostListLoaded(data!));
    } catch (e) {
      emit(ExploreShopPostListFailure(e));
    }
  }

}
