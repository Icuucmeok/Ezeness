import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ezeness/data/models/my_favourite_response.dart';
import 'package:ezeness/data/repositories/profile_repository.dart';


part 'my_favourite_state.dart';

class MyFavouriteCubit extends Cubit<MyFavouriteState> {
  final ProfileRepository _profileRepository;
  MyFavouriteCubit(this._profileRepository) : super(MyFavouriteInitial());

  void getMyFavourites() async {
    emit(MyFavouriteListLoading());
    try {
      final data =  await _profileRepository.getMyFavourites();
      emit(MyFavouriteListLoaded(data!));
    } catch (e) {
      emit(MyFavouriteListFailure(e));
    }
  }
}
