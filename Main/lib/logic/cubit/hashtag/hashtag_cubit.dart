import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:ezeness/data/models/hashtag/hashtag.dart';
import 'package:ezeness/data/repositories/post_repository.dart';
import 'package:ezeness/data/utils/error_handler.dart';
import 'package:ezeness/data/utils/errors.dart';

import '../../../data/models/hashtag/hashtag_list.dart';

part 'hashtag_state.dart';

class HashtagCubit extends Cubit<HashtagState> {
  final PostRepository _postRepository;
  HashtagCubit(this._postRepository) : super(HashtagInitial());

  void getHashtag(String search) async {
    emit(HashtagLoading());
    try {
      final data = await _postRepository.getHashtag(search);
      emit(HashtagLoaded(data!));
    } catch (e) {
      emit(HashtagFailure(e));
    }
  }

  Future<HashtagModel?> getHashtagByName(String hashtag) async {
    try {
      hashtag = hashtag.replaceAll("#", '');
      final data = await _postRepository.getHashtag(hashtag);

      HashtagModel? result = data?.hashtagList
          ?.firstWhereOrNull((element) => element.name == hashtag);

      if (result == null)
        throw ServerException(
          message: "The hashtag you are trying to reach does not exist!",
        );
      return result;
    } catch (e, s) {
      throw ErrorHandler(exception: e, stackTrace: s).rethrowError();
    }
  }
}
