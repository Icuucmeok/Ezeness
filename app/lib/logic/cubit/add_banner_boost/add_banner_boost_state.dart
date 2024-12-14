part of 'add_banner_boost_cubit.dart';

class AddBannerBoostState extends Equatable {
  const AddBannerBoostState();

  @override
  List<Object> get props => [];
}

class AddBannerBoostInitial extends AddBannerBoostState {}

class AddBannerBoostLoading extends AddBannerBoostState {}

class AddBannerBoostFailure extends AddBannerBoostState {
  final Object exception;

  const AddBannerBoostFailure(this.exception);
  @override
  List<Object> get props => [exception];
}

class AddBannerBoostDone extends AddBannerBoostState {
  const AddBannerBoostDone();
}
