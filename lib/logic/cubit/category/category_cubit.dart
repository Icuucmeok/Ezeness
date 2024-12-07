import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ezeness/data/models/category/category.dart';
import '../../../data/models/category/category_list.dart';
import '../../../data/repositories/category_repository.dart';

part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  final CategoryRepository _categoryRepository;
  CategoryCubit(this._categoryRepository) : super(CategoryInitial());


  void emitCategories(List<Category> list) async{
     await Future.delayed(Duration(milliseconds: 200));
     emit(CategoriesLoaded(CategoryList(categoryList: list)));
  }

  void getCategories({bool withKidsContent=true,required int isForKids,int? isVip}) async  {
    emit(CategoriesLoading());
    try {
      final data =  await _categoryRepository.getCategories(withKidsContent:withKidsContent,isForKids: isForKids,isVip: isVip);
      emit(CategoriesLoaded(data!));
    } catch (e) {
      emit(CategoriesFailure(e));
    }
  }

  void getChildCategories({bool withKidsContent=true,required int parentCategoryId,required int isForKids,int? postType,int? userId,int? isVip}) async {
    emit(ChildCategoryLoading());
    try {
      final data =  await _categoryRepository.getCategories(withKidsContent:withKidsContent,parentCategoryId: parentCategoryId,isForKids: isForKids,postType: postType,userId:userId,isVip: isVip);
      emit(ChildCategoryLoaded(data!));
    } catch (e) {
      emit(ChildCategoryFailure(e));
    }
  }


  void getSubCategories({bool withKidsContent=true,required int parentCategoryId,required int isForKids}) async {
    emit(SubCategoryLoading());
    try {
      final data =  await _categoryRepository.getCategories(withKidsContent:withKidsContent,parentCategoryId: parentCategoryId,isForKids: isForKids);
      emit(SubCategoryLoaded(data!));
    } catch (e) {
      emit(SubCategoryFailure(e));
    }
  }

  void getCategory(int id) async {
    emit(CategoryLoading());
    try {
      final data =  await _categoryRepository.getCategory(id);
      emit(CategoryLoaded(data!));
    } catch (e) {
      emit(CategoryFailure(e));
    }
  }
}
