import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ezeness/data/models/boost/plans/boost_plans_list.dart';
import 'package:ezeness/data/repositories/boost_repository.dart';

part 'post_plans_state.dart';

class PostPlansCubit extends Cubit<PostPlansState> {
  final BoostRepository boostRepository;

  PostPlansCubit(this.boostRepository) : super(PostPlansInitial());

  void getPostsPlans({required int? postType, required int? isKids}) async {
    emit(PostPlansLoading());
    try {
      final data = await boostRepository.getPostPlans();
      emit(PostPlansDone(data));
    } catch (e) {
      emit(PostPlansFailure(e));
    }
  }
}
