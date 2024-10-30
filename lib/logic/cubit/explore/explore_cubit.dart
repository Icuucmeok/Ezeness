import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ezeness/data/repositories/explore_repository.dart';
part 'explore_state.dart';

class ExploreCubit extends Cubit<ExploreState> {
  final ExploreRepository _exploreRepository;
  ExploreCubit(this._exploreRepository) : super(ExploreInitial());

  void animateToShop() async {
    emit(ExploreAnimateToShop());
  }

}
