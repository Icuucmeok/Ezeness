import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ezeness/presentation/utils/helpers.dart';
import 'package:ezeness/res/app_res.dart';
import '../../../data/models/post/post_list.dart';
import '../../../data/repositories/post_repository.dart';


part 'discover_post_state.dart';

class DiscoverPostCubit extends Cubit<DiscoverPostState> {
  final PostRepository _postRepository;
  DiscoverPostCubit(this._postRepository) : super(DiscoverPostInitial());

  static int homeDiscoverCode=0;
  static int shopDiscoverCode=0;
  static int socialDiscoverCode=0;
  static int kidsDiscoverCode=0;

  static int getDiscoverCode(String tabType){
    if(tabType==Constants.homeTabKey){
      return homeDiscoverCode;
    }
    if(tabType==Constants.shopTabKey){
      return shopDiscoverCode;
    }
    if(tabType==Constants.socialTabKey){
      return socialDiscoverCode;
    }
    if(tabType==Constants.kidsTabKey){
      return kidsDiscoverCode;
    }
    return 0;
  }


  void getDiscoverHomeList() async {
    emit(DiscoverHomeListLoading());
    homeDiscoverCode=Helpers.getRandomNumber();
    try {
      final data =  await _postRepository.getDiscoverPosts(Constants.homeTabKey,discoverCode: getDiscoverCode(Constants.homeTabKey));
      emit(DiscoverHomeListLoaded(data!));
    } catch (e) {
      emit(DiscoverHomeListFailure(e));
    }
  }

  void getDiscoverShopList() async {
    emit(DiscoverShopListLoading());
    shopDiscoverCode=Helpers.getRandomNumber();
    try {
      final data =  await _postRepository.getDiscoverPosts(Constants.shopTabKey,discoverCode: getDiscoverCode(Constants.shopTabKey));
      emit(DiscoverShopListLoaded(data!));
    } catch (e) {
      emit(DiscoverShopListFailure(e));
    }
  }

  void getDiscoverSocialList() async {
    emit(DiscoverSocialListLoading());
    socialDiscoverCode=Helpers.getRandomNumber();
    try {
      final data =  await _postRepository.getDiscoverPosts(Constants.socialTabKey,discoverCode: getDiscoverCode(Constants.socialTabKey));
      emit(DiscoverSocialListLoaded(data!));
    } catch (e) {
      emit(DiscoverSocialListFailure(e));
    }
  }

  void getDiscoverKidsList() async {
    emit(DiscoverKidsListLoading());
    kidsDiscoverCode=Helpers.getRandomNumber();
    try {
      final data =  await _postRepository.getDiscoverPosts(Constants.kidsTabKey,discoverCode: getDiscoverCode(Constants.kidsTabKey));
      emit(DiscoverKidsListLoaded(data!));
    } catch (e) {
      emit(DiscoverKidsListFailure(e));
    }
  }




}
