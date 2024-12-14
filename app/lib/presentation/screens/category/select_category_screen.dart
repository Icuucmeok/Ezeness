import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ezeness/data/models/category/category.dart';
import 'package:ezeness/logic/cubit/category/category_cubit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../data/utils/error_handler.dart';
import '../../../generated/l10n.dart';
import '../../widgets/category_widget.dart';
import '../../widgets/common/common.dart';

class SelectCategoryScreen extends StatefulWidget {
  static const String routName = 'select_category_screen';
  final args;
  const SelectCategoryScreen({this.args, Key? key}) : super(key: key);

  @override
  State<SelectCategoryScreen> createState() => _SelectCategoryScreenState();
}

class _SelectCategoryScreenState extends State<SelectCategoryScreen> {
  late CategoryCubit _categoryCubit;
  List<Category> oldList = [];
  List<Category> newList = [];
  List<Category> TempOldList = [];
  int? selectedCategoryId;
  Category? selectedCategory;
  Category? selectedLastCategory;
  int? postType;
  int isForKids = 0;
  List<Category>? passedCategoryList;
  List<Category> selectedCategoryHistory = [];
  @override
  void initState() {
    _categoryCubit = context.read<CategoryCubit>();
    if (widget.args != null) {
      if (widget.args["selectedCategory"] != null) {
        selectedCategory = widget.args["selectedCategory"] as Category;
        selectedCategoryId = selectedCategory?.id!;
      }
      if (widget.args["isForKids"] != null) {
        isForKids = widget.args["isForKids"] as int;
      }
      if (widget.args["postType"] != null) {
        postType = widget.args["postType"] as int?;
      }

      if (widget.args["categoryList"] != null) {
        passedCategoryList = widget.args["categoryList"] as List<Category>?;
      }
    }
    if (passedCategoryList != null) {
      _categoryCubit.emitCategories(passedCategoryList!);
    } else {
      _categoryCubit.getCategories(isForKids: isForKids);
    }

    super.initState();
  }

  onBack() async {
    if (selectedLastCategory != null)
      setState(() {
        selectedLastCategory = null;
      });

    if (selectedCategoryHistory.isEmpty) {
      Navigator.pop(context);
    } else {
      Category temp = selectedCategoryHistory.last;
      selectedCategory = temp;
      selectedCategoryId = temp.id;
      if (selectedCategoryHistory.length == 1) {
        if (passedCategoryList != null) {
          _categoryCubit.emitCategories(passedCategoryList!);
        } else {
          _categoryCubit.getCategories(isForKids: isForKids);
        }
      } else {
        oldList = TempOldList;
        _categoryCubit.getChildCategories(
          parentCategoryId: temp.id!,
          isForKids: isForKids,
          withKidsContent: true,
          postType: postType,
        );
      }
      selectedCategoryHistory.removeLast();
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
   return WillPopScope(
      onWillPop: () async {
        onBack();
        return Future.value(false); 
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading:
              IconButton(onPressed: onBack, icon: Icon(Icons.arrow_back_ios)),
          title: BlocBuilder<CategoryCubit, CategoryState>(
              builder: (context, state) {
            return selectedCategory == null
                ? SizedBox()
                : Text(selectedCategory!.name.toString(),
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          letterSpacing: 0.2,
                          height: 1.2.h,
                          fontWeight: FontWeight.w600,
                          fontSize: 14.0.sp,
                        ));
          }),
          actions: [
            if (selectedLastCategory != null)
              TextButton(
                  onPressed: () {
                    selectedCategoryHistory.add(selectedLastCategory!);
                    Navigator.pop(context, [selectedCategoryHistory[0],selectedCategoryHistory[1],selectedCategoryHistory[2]]);
                  },
                  child: Text(S.current.next)),
          ],
        ),
        body: BlocConsumer<CategoryCubit, CategoryState>(
            bloc: _categoryCubit,
            listener: (context, state) {
              if (state is ChildCategoryLoaded) {
                newList = state.response.categoryList!;
              }
              if (state is CategoriesLoaded) {
                selectedCategoryHistory.clear();
                oldList = state.response.categoryList!;
                if (selectedCategory == null) {
                  selectedCategory = oldList.first;
                  selectedCategoryId = selectedCategory?.id!;
                }
                if (selectedCategory != null) {
                  _categoryCubit.getChildCategories(
                    parentCategoryId: selectedCategory!.id!,
                    isForKids: isForKids,
                    withKidsContent: true,
                    postType: postType,
                  );
                }
              }
            },
            builder: (context, state) {
              if (state is CategoriesLoading) {
                return const CenteredCircularProgressIndicator();
              }
              if (state is CategoriesFailure) {
                return ErrorHandler(exception: state.exception)
                    .buildErrorWidget(
                        context: context,
                        retryCallback: () =>
                            _categoryCubit.getCategories(isForKids: isForKids));
              }
              if (state is CategoriesLoaded) {
                return GridView.count(
                  crossAxisCount:
                      MediaQuery.of(context).size.width > 600.w ? 5 : 4,
                  crossAxisSpacing: 2.0,
                  mainAxisSpacing: 2.0,
                  shrinkWrap: true,
                  childAspectRatio: 0.8,
                  children: state.response.categoryList!
                      .map((e) => CategoryWidget(
                          onTap: () {
                            selectedCategoryId = e.id!;
                            selectedCategory = e;
                            _categoryCubit.getChildCategories(
                              parentCategoryId: e.id!,
                              withKidsContent: true,
                              isForKids: isForKids,
                              postType: postType,
                            );
                          },
                          category: e))
                      .toList(),
                );
              }
              return Container(
                padding: EdgeInsets.symmetric(vertical: 0.0),
                alignment: Alignment.topCenter,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.topCenter,
                      width: .275.sw,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Container(
                          alignment: Alignment.topCenter,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: oldList
                                .map((e) => Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          2.0, 0.0, 2.0, 0.0),
                                      child: CategoryWidget(
                                          onTap: () {
                                            selectedCategoryId = e.id!;
                                            selectedCategory = e;
                                            _categoryCubit.getChildCategories(
                                              parentCategoryId: e.id!,
                                              isForKids: isForKids,
                                              withKidsContent: true,
                                              postType: postType,
                                            );
                                          },
                                          category: e,
                                          isSelected:
                                              selectedCategoryId == e.id),
                                    ))
                                .toList(),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                        child: state is ChildCategoryFailure
                            ? ErrorHandler(exception: state.exception)
                                .buildErrorWidget(
                                    context: context,
                                    retryCallback: () =>
                                        _categoryCubit.getChildCategories(
                                          parentCategoryId: selectedCategoryId!,
                                          isForKids: isForKids,
                                          withKidsContent: true,
                                          postType: postType,
                                        ))
                            : state is ChildCategoryLoading
                                ? const CenteredCircularProgressIndicator()
                                : GridView.count(
                                    crossAxisCount:
                                        MediaQuery.of(context).size.width > 600
                                            ? 4
                                            : 3,
                                    crossAxisSpacing: 2.0,
                                    mainAxisSpacing: 2.0,
                                    shrinkWrap: true,
                                    childAspectRatio: 0.8,
                                    children: newList
                                        .map((e) => Container(
                                              padding: EdgeInsets.fromLTRB(
                                                  2.0.w, 2.0.h, 0.0, 0.0),
                                              alignment: Alignment.topCenter,
                                              child: CategoryWidget(
                                                  onTap: () {
                                                    if (selectedCategoryHistory
                                                            .length <
                                                        2) {
                                                      selectedCategoryHistory
                                                          .add(
                                                              selectedCategory!);
                                                    }
                                                    if (e.isLast == true) {
                                                      setState(() {
                                                        selectedLastCategory =
                                                            e;
                                                      });
                                                    } else {
                                                      selectedCategoryId =
                                                          e.id!;
                                                      selectedCategory = e;
                                                      TempOldList = oldList;
                                                      oldList = newList;
                                                      _categoryCubit
                                                          .getChildCategories(
                                                        parentCategoryId: e.id!,
                                                        isForKids: isForKids,
                                                        postType: postType,
                                                        withKidsContent: true,
                                                      );
                                                    }
                                                  },
                                                  category: e,
                                                  isSelected:
                                                      selectedLastCategory
                                                              ?.id ==
                                                          e.id),
                                            ))
                                        .toList(),
                                  )),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
