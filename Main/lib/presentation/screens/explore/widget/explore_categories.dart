import 'package:ezeness/presentation/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../data/models/category/category.dart';
import '../../../../data/models/user/user.dart';
import '../../../../generated/l10n.dart';
import '../../../../logic/cubit/app_config/app_config_cubit.dart';
import '../../../../res/app_res.dart';
import '../../../router/app_router.dart';
import '../../../widgets/category_widget.dart';
import '../../../widgets/common/common.dart';
import '../../category/category_screen.dart';

class ExploreCategories extends StatefulWidget {
  final int postType;
  final List<Category> categoryList;
  final bool isKids;
  const ExploreCategories(
      {required this.postType,
      required this.categoryList,
      this.isKids = false,
      Key? key})
      : super(key: key);

  @override
  State<ExploreCategories> createState() => _ExploreCategoriesState();
}

class _ExploreCategoriesState extends State<ExploreCategories> {
  @override
  Widget build(BuildContext context) {
    User loggedInUser = context.read<AppConfigCubit>().getUser();
    return widget.categoryList.isEmpty
        ? SizedBox()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ViewAllIconHeader(
                  leadingText: S.current.menu,
                  onNavigate: () {
                    Navigator.of(AppRouter.mainContext)
                        .pushNamed(CategoryScreen.routName, arguments: {
                      "postType": widget.postType,
                      if (widget.isKids) "isForKids": 1,
                      "categoryList": widget.categoryList
                    });
                  }),
              GridView(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: Helpers.isTab(context) ? 7 : 4,
                  childAspectRatio: 0.65,
                ),
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(horizontal: 5),
                children: [
                  if (loggedInUser.type == Constants.specialInviteKey)
                    CategoryWidget(
                      margin: EdgeInsets.symmetric(
                          horizontal: 5.dg, vertical: 10.dg),
                      onTap: () {
                        Navigator.of(AppRouter.mainContext)
                            .pushNamed(CategoryScreen.routName, arguments: {
                          "postType": widget.postType,
                          if (widget.isKids) "isForKids": 1,
                          "isVip": 1
                        });
                      },
                      category: AppData.vipCategory,
                    ),
                  ...widget.categoryList
                      .map((e) => CategoryWidget(
                          margin: EdgeInsets.symmetric(
                              horizontal: 5.dg, vertical: 10.dg),
                          onTap: () {
                            Navigator.of(AppRouter.mainContext)
                                .pushNamed(CategoryScreen.routName, arguments: {
                              "selectedCategory": e,
                              "postType": widget.postType,
                              if (widget.isKids) "isForKids": 1,
                              "categoryList": widget.categoryList
                            });
                          },
                          category: e))
                      .toList(),
                ],
              ),
            ],
          );
  }
}
