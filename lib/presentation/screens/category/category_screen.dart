import 'package:ezeness/data/models/user/user.dart';
import 'package:ezeness/data/models/post/post.dart';
import 'package:ezeness/logic/cubit/category_post/category_post_cubit.dart';
import 'package:ezeness/presentation/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ezeness/data/models/category/category.dart';
import 'package:ezeness/logic/cubit/category/category_cubit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../data/utils/error_handler.dart';
import '../../../logic/cubit/app_config/app_config_cubit.dart';
import '../../../res/app_res.dart';
import '../../router/app_router.dart';
import '../../widgets/category_widget.dart';
import '../../widgets/common/common.dart';
import '../../widgets/post_grid_view.dart';

class CategoryScreen extends StatefulWidget {
  static const String routName = 'category_screen';
  final args;
  const CategoryScreen({this.args, Key? key}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  late CategoryCubit _categoryCubit;
  late CategoryPostCubit _categoryPostCubit;
  List<Category> oldList = [];
  List<Category> newList = [];
  List<Category> TempOldList = [];
  int? selectedCategoryId;
  Category? selectedCategory;
  bool isMine = false;
  User? user;
  int? postType;
  int isForKids = 0;
  int isVip = 0;
  List<Category>? passedCategoryList;
  List<Category> selectedCategoryHistory = [];
  @override
  void initState() {
    _categoryPostCubit = context.read<CategoryPostCubit>();
    _categoryCubit = context.read<CategoryCubit>();
    if (widget.args != null) {
      if (widget.args["isMine"] != null) {
        isMine = widget.args["isMine"] as bool;
      }
      if (widget.args["selectedCategory"] != null) {
        selectedCategory = widget.args["selectedCategory"] as Category;
        selectedCategoryId = selectedCategory?.id!;
      }
      if (widget.args["user"] != null) {
        user = widget.args["user"] as User;
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

      if (widget.args["isVip"] != null) {
        isVip = widget.args["isVip"] as int;
      }
    }
    if (passedCategoryList != null) {
      _categoryCubit.emitCategories(passedCategoryList!);
    } else {
      _categoryCubit.getCategories(isForKids: isForKids, isVip: isVip);
    }

    super.initState();
  }

  onBack() async {
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
          _categoryCubit.getCategories(isForKids: isForKids, isVip: isVip);
        }
      } else {
        oldList = TempOldList;
        _categoryCubit.getChildCategories(
            parentCategoryId: temp.id!,
            isForKids: isForKids,
            postType: postType,
            userId: user == null ? null : user?.id,
            isVip: isVip);
      }
      selectedCategoryHistory.removeLast();
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    User loggedInUser = context.read<AppConfigCubit>().getUser();
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object) {
        if (didPop) {
          return;
        }
        onBack();
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
            if (isVip == 1) ImageIconButton(imageIcon: Constants.vipImage),
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
                      postType: postType,
                      userId: user == null ? null : user?.id,
                      isVip: isVip);
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
                        retryCallback: () => _categoryCubit.getCategories(
                            isForKids: isForKids, isVip: isVip));
              }
              if (state is CategoriesLoaded) {
                return GridView.count(
                  crossAxisCount: Helpers.isTab(context) ? 5 : 3,
                  crossAxisSpacing: 2.0,
                  mainAxisSpacing: 2.0,
                  shrinkWrap: true,
                  childAspectRatio: 0.68,
                  children: state.response.categoryList!
                      .map((e) => CategoryWidget(
                          onTap: () {
                            selectedCategoryId = e.id!;
                            selectedCategory = e;
                            _categoryCubit.getChildCategories(
                                parentCategoryId: e.id!,
                                isForKids: isForKids,
                                postType: postType,
                                userId: user == null ? null : user?.id,
                                isVip: isVip);
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
                            children: [
                              if (user == null &&
                                  loggedInUser.type ==
                                      Constants.specialInviteKey &&
                                  selectedCategoryHistory.isEmpty &&
                                  isForKids == 0 &&
                                  isVip == 0)
                                Padding(
                                  padding:
                                      EdgeInsets.fromLTRB(2.0, 0.0, 2.0, 0.0),
                                  child: CategoryWidget(
                                      onTap: () {
                                        Navigator.of(AppRouter.mainContext)
                                            .pushNamed(CategoryScreen.routName,
                                                arguments: {
                                              "postType": postType,
                                              "isVip": 1
                                            });
                                      },
                                      category: AppData.vipCategory),
                                ),
                              ...oldList
                                  .map((e) => Padding(
                                        padding: EdgeInsets.fromLTRB(
                                            2.0, 0.0, 2.0, 0.0),
                                        child: CategoryWidget(
                                            onTap: () {
                                              selectedCategoryId = e.id!;
                                              selectedCategory = e;
                                              if (selectedCategory!.isLast!) {
                                                setState(() {});
                                                _categoryPostCubit
                                                    .getPostsByCategoryId(
                                                        id: selectedCategoryId!,
                                                        isMine: isMine,
                                                        userId: user?.id,
                                                        postType: postType,
                                                        isForKids: isForKids,
                                                        isVip: isVip);
                                              } else {
                                                _categoryCubit
                                                    .getChildCategories(
                                                        parentCategoryId: e.id!,
                                                        isForKids: isForKids,
                                                        postType: postType,
                                                        userId: user == null
                                                            ? null
                                                            : user?.id,
                                                        isVip: isVip);
                                              }
                                            },
                                            category: e,
                                            isSelected:
                                                selectedCategoryId == e.id),
                                      ))
                                  .toList(),
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (selectedCategory != null &&
                        selectedCategory!.isLast!) ...{
                      Expanded(
                        child:
                            BlocBuilder<CategoryPostCubit, CategoryPostState>(
                                bloc: _categoryPostCubit,
                                builder: (context, state) {
                                  if (state is CategoryPostListLoading) {
                                    return const CenteredCircularProgressIndicator();
                                  }
                                  if (state is CategoryPostListFailure) {
                                    return ErrorHandler(
                                            exception: state.exception)
                                        .buildErrorWidget(
                                            context: context,
                                            retryCallback: () =>
                                                _categoryPostCubit
                                                    .getPostsByCategoryId(
                                                        id: selectedCategoryId!,
                                                        isMine: isMine,
                                                        userId: user?.id,
                                                        postType: postType,
                                                        isForKids: isForKids,
                                                        isVip: isVip));
                                  }
                                  if (state is CategoryPostListLoaded) {
                                    List<Post> list = state.response.postList!;
                                    return PostGridView(list,
                                        onPostTapShowInList: true,
                                        isScroll: true,
                                        minSpacing: 3);
                                  }
                                  return Container();
                                }),
                      ),
                    } else ...{
                      Expanded(
                          child: state is ChildCategoryFailure
                              ? ErrorHandler(exception: state.exception)
                                  .buildErrorWidget(
                                      context: context,
                                      retryCallback: () =>
                                          _categoryCubit.getChildCategories(
                                              parentCategoryId:
                                                  selectedCategoryId!,
                                              isForKids: isForKids,
                                              postType: postType,
                                              userId: user == null
                                                  ? null
                                                  : user?.id,
                                              isVip: isVip))
                              : state is ChildCategoryLoading
                                  ? const CenteredCircularProgressIndicator()
                                  : GridView.count(
                                      crossAxisCount:
                                          Helpers.isTab(context) ? 5 : 3,
                                      crossAxisSpacing: 2.0,
                                      mainAxisSpacing: 2.0,
                                      shrinkWrap: true,
                                      childAspectRatio: 0.68,
                                      children: newList
                                          .map((e) => Container(
                                                padding: EdgeInsets.fromLTRB(
                                                    2.0.w, 2.0.h, 0.0, 0.0),
                                                alignment: Alignment.topCenter,
                                                child: CategoryWidget(
                                                    onTap: () {
                                                      selectedCategoryHistory
                                                          .add(
                                                              selectedCategory!);
                                                      selectedCategoryId =
                                                          e.id!;
                                                      selectedCategory = e;
                                                      if (selectedCategory!
                                                          .isLast!) {
                                                        _categoryPostCubit
                                                            .getPostsByCategoryId(
                                                                id:
                                                                    selectedCategoryId!,
                                                                isMine: isMine,
                                                                userId:
                                                                    user?.id,
                                                                postType:
                                                                    postType,
                                                                isForKids:
                                                                    isForKids,
                                                                isVip: isVip);
                                                      }
                                                      TempOldList = oldList;
                                                      oldList = newList;
                                                      _categoryCubit
                                                          .getChildCategories(
                                                              parentCategoryId:
                                                                  e.id!,
                                                              isForKids:
                                                                  isForKids,
                                                              postType:
                                                                  postType,
                                                              userId: user ==
                                                                      null
                                                                  ? null
                                                                  : user?.id,
                                                              isVip: isVip);
                                                    },
                                                    category: e),
                                              ))
                                          .toList(),
                                    )),
                    },
                  ],
                ),
              );
            }),
      ),
    );
  }
}
