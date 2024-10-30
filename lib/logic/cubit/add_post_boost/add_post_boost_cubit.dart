import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ezeness/data/repositories/boost_repository.dart';

part 'add_post_boost_state.dart';

class AddPostBoostCubit extends Cubit<AddPostBoostState> {
  final BoostRepository boostRepository;

  AddPostBoostCubit(this.boostRepository) : super(AddPostBoostInitial());

  void addPostBoost({
    required int? postId,
    required int planId,
    required String? startDate,
  }) async {
    emit(AddPostBoostLoading());
    try {
      await boostRepository.addPostBoost(
        postId: postId,
        planId: planId,
        startDate: startDate,
      );
      emit(AddPostBoostDone());
    } catch (e) {
      emit(AddPostBoostFailure(e));
    }
  }
}
