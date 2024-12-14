import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ezeness/presentation/utils/helpers.dart';
import 'package:ezeness/res/app_res.dart';
import '../../../data/models/post/post_list.dart';
import '../../../data/repositories/post_repository.dart';


part 'explore_post_state.dart';

class ExplorePostCubit extends Cubit<ExplorePostState> {
  final PostRepository _postRepository;
  ExplorePostCubit(this._postRepository) : super(ExplorePostInitial());

  static int trendingSectionRandomCode=0;
  static int forYouSectionRandomCode=0;
  void getExploreSectionPostList({required String sectionKey,required String tabType}) async {

    if(sectionKey==Constants.forYouSectionKey){
      forYouSectionRandomCode=Helpers.getRandomNumber();
    }

    if(sectionKey==Constants.trendingSectionKey){
      trendingSectionRandomCode=Helpers.getRandomNumber();
    }
    emit(ExploreSectionPostListLoading());
    try {
      final data =  await _postRepository.getExploreSectionPostList(sectionKey,tabType);
      emit(ExploreSectionPostListLoaded(data!));
    } catch (e) {
      emit(ExploreSectionPostListFailure(e));
    }
  }

}
