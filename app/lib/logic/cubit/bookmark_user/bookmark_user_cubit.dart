import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ezeness/data/repositories/profile_repository.dart';
part 'bookmark_user_state.dart';


class BookmarkUserCubit extends Cubit<BookmarkUserState> {
  final ProfileRepository _profileRepository;
  BookmarkUserCubit(this._profileRepository) : super(BookmarkUserInitial());


  void bookmarkUnBookmarkUser(int userId) async {
    emit(BookmarkUserLoading());
    try {
     final data =  await _profileRepository.bookmarkUnBookmarkUser(userId);
     emit(BookmarkUserDone(data!));
    } catch (e) {
      emit(BookmarkUserFailure(e));
    }
  }
}
