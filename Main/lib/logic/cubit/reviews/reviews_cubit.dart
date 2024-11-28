import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ezeness/data/repositories/profile_repository.dart';

import '../../../data/models/review/review.dart';

part 'reviews_state.dart';

class ReviewsCubit extends Cubit<ReviewsState> {
  final ProfileRepository _profileRepository;
  ReviewsCubit(this._profileRepository) : super(ReviewsInitial());

  void addReviews({
    required int reviewedUserId,
    required String reviews,
    required int rate,
  }) async {
    emit(ReviewsLoading());
    try {
      final data =
          await _profileRepository.addReview(reviewedUserId, reviews, rate);
      emit(ReviewsAdded(data!));
    } catch (e) {
      emit(ReviewsFailure(e));
    }
  }

  void deleteReviews(int id) async {
    emit(ReviewsLoading());
    try {
      final data = await _profileRepository.deleteReviews(id);
      emit(ReviewsDeleted(data!));
    } catch (e) {
      emit(ReviewsFailure(e));
    }
  }
}
