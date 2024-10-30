part of 'banner_plans_cubit.dart';

class BannerPlansState extends Equatable {
  const BannerPlansState();

  @override
  List<Object> get props => [];
}

class BannerPlansInitial extends BannerPlansState {}

class BannerPlansLoading extends BannerPlansState {}

class BannerPlansFailure extends BannerPlansState {
  final Object exception;

  const BannerPlansFailure(this.exception);
  @override
  List<Object> get props => [exception];
}

class BannerPlansDone extends BannerPlansState {
  final BoostPlansList? bannersPlansList;
  const BannerPlansDone(this.bannersPlansList);
}
