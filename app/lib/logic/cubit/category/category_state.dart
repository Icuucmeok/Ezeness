part of 'category_cubit.dart';


abstract class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object> get props => [];
}

class CategoryInitial extends CategoryState {}

class CategoryLoading extends CategoryState {}
class CategoryFailure extends CategoryState {
  final Object exception;

  const CategoryFailure(this.exception);
    @override
  List<Object> get props => [exception];
}
class CategoryLoaded extends CategoryState {
  final Category response;

  const CategoryLoaded(this.response);
  @override
  List<Object> get props => [response];

}


class CategoriesLoading extends CategoryState {}
class CategoriesFailure extends CategoryState {
  final Object exception;

  const CategoriesFailure(this.exception);
  @override
  List<Object> get props => [exception];
}
class CategoriesLoaded extends CategoryState {
  final CategoryList response;

  const CategoriesLoaded(this.response);
  @override
  List<Object> get props => [response];

}


class ChildCategoryLoading extends CategoryState {}
class ChildCategoryFailure extends CategoryState {
  final Object exception;

  const ChildCategoryFailure(this.exception);
  @override
  List<Object> get props => [exception];
}
class ChildCategoryLoaded extends CategoryState {
  final CategoryList response;

  const ChildCategoryLoaded(this.response);
  @override
  List<Object> get props => [response];

}


class SubCategoryLoading extends CategoryState {}
class SubCategoryFailure extends CategoryState {
  final Object exception;

  const SubCategoryFailure(this.exception);
  @override
  List<Object> get props => [exception];
}
class SubCategoryLoaded extends CategoryState {
  final CategoryList response;

  const SubCategoryLoaded(this.response);
  @override
  List<Object> get props => [response];

}


