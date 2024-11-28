import 'package:ezeness/presentation/screens/filter_screen.dart';
import 'package:ezeness/presentation/screens/discover/discover_post_page.dart';
import 'package:ezeness/presentation/utils/helpers.dart';
import 'package:ezeness/res/app_res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';

import '../../../generated/l10n.dart';
import '../../../logic/cubit/app_config/app_config_cubit.dart';
import '../../../logic/cubit/session_controller/session_controller_cubit.dart';

class DiscoverScreen extends StatefulWidget {
  static const String routName = 'discover_screen';

  const DiscoverScreen({Key? key}) : super(key: key);

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen>
    with TickerProviderStateMixin {
  PageController homeController = PageController();
  PageController shopController = PageController();
  PageController socialController = PageController();
  PageController kidsController = PageController();
  late TabController _tabController;
  List<Widget> tabs = [];
  bool isKids = false;
  void goUp() {
    if (socialController.hasClients) {
      socialController.animateToPage(0,
          curve: Curves.easeIn, duration: Duration(milliseconds: 500));
    }
    if (homeController.hasClients) {
      homeController.animateToPage(0,
          curve: Curves.easeIn, duration: Duration(milliseconds: 500));
    }
    if (shopController.hasClients) {
      shopController.animateToPage(0,
          curve: Curves.easeIn, duration: Duration(milliseconds: 500));
    }
    if (kidsController.hasClients) {
      kidsController.animateToPage(0,
          curve: Curves.easeIn, duration: Duration(milliseconds: 500));
    }
  }

  @override
  void initState() {
    isKids = context.read<SessionControllerCubit>().getIsKids() == 1;
    tabs = [
      Tab(
        text: S.current.home.toUpperCase(),
      ),
      Tab(
        text: S.current.shop.toUpperCase(),
      ),
      Tab(
        text: S.current.social.toUpperCase(),
      ),
      if (!isKids)
        Tab(
          text: S.current.kids.toUpperCase(),
        ),
    ];
    _tabController = TabController(length: tabs.length, vsync: this);
    context.read<AppConfigCubit>().setDiscoverScreenGoUp(goUp);
    _tabController.addListener(() {
      context.read<AppConfigCubit>().setDiscoverScreenGoUp(goUp);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          TabBarView(
            // physics: const NeverScrollableScrollPhysics(),
            controller: _tabController,
            children: [
              DiscoverPostPage(Constants.homeTabKey, homeController),
              DiscoverPostPage(Constants.shopTabKey, shopController),
              DiscoverPostPage(Constants.socialTabKey, socialController),
              if (!isKids)
                DiscoverPostPage(Constants.kidsTabKey, kidsController),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.black.withOpacity(0.2), Colors.transparent],
                stops: [0.2, 1],
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TabBar(
                    controller: _tabController,
                    labelColor: Colors.white,
                    indicatorWeight: 0.1,
                    unselectedLabelColor: Colors.white,
                    unselectedLabelStyle: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontSize: 14),
                    labelStyle: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontSize: 14, fontWeight: FontWeight.bold),
                    tabs: tabs
                        .map((e) => Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              child: e,
                            ))
                        .toList(),
                  ),
                ),
                if (Helpers.isTab(context)) Spacer(),
                IconButton(
                  onPressed: () =>
                      Navigator.of(context).pushNamed(FilterScreen.routName),
                  icon: Icon(
                    IconlyLight.filter,
                    size: 23,
                    color: AppColors.whiteColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
