import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ezeness/data/models/review/review_list.dart';
import 'package:ezeness/data/repositories/profile_repository.dart';
part 'user_reviews_state.dart';


class UserReviewsCubit extends Cubit<UserReviewsState> {
  final ProfileRepository _profileRepository;
  UserReviewsCubit(this._profileRepository) : super(UserReviewsInitial());


  void getReviews(int userId) async {
    emit(UserReviewsLoading());
    try {
      final data =  await _profileRepository.getReviews(userId);
      emit(UserReviewsLoaded(data!));
    } catch (e) {
      emit(UserReviewsFailure(e));
    }
  }
}
