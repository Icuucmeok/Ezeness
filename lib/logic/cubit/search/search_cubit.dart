import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/search_response.dart';
import '../../../data/repositories/search_repository.dart';
part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final SearchRepository _searchRepository;
  SearchCubit(this._searchRepository) : super(SearchInitial());

  void search(text) async {
    emit(SearchLoading());
    try {
      final data =  await _searchRepository.search(text);
      emit(SearchResponseLoaded(data!));
    } catch (e) {
      emit(SearchFailure(e));
    }
  }




}
