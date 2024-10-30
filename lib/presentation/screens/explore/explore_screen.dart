import 'package:ezeness/presentation/screens/explore/explore_home_page.dart';
import 'package:ezeness/presentation/screens/explore/explore_kids_page.dart';
import 'package:ezeness/presentation/screens/explore/explore_shop_page.dart';
import 'package:ezeness/presentation/screens/explore/explore_social_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import '../../../generated/l10n.dart';
import '../../../logic/cubit/explore/explore_cubit.dart';
import '../../../logic/cubit/session_controller/session_controller_cubit.dart';
import '../../utils/helpers.dart';
import '../../widgets/common/common.dart';
import '../filter_screen.dart';

class ExploreScreen extends StatefulWidget {
  static const String routName = 'explore_screen';

  const ExploreScreen({Key? key}) : super(key: key);

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen>
    with TickerProviderStateMixin {
  late ExploreCubit _exploreCubit;
  late TabController _tabController;
  List<Widget> tabs=[];
  bool isKids=false;
  @override
  void initState() {
    _exploreCubit = context.read<ExploreCubit>();
    isKids=context.read<SessionControllerCubit>().getIsKids()==1;
    tabs=[
      Tab(
        text: S.current.home.toUpperCase(),
      ),
      Tab(
        text: S.current.shop.toUpperCase(),
      ),
      Tab(
        text: S.current.social.toUpperCase(),
      ),
      if(!isKids)
        Tab(
          text: S.current.kids.toUpperCase(),
        ),
    ];
    _tabController = TabController(length: tabs.length, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<ExploreCubit, ExploreState>(
        bloc: _exploreCubit,
        listener: (context, state) {
          if (state is ExploreAnimateToShop) {
            _tabController.animateTo(1);
          }
        },
        child: Column(
          children: [
            const SearchButton(),
            Row(
              children: [
                Expanded(
                  child: TabBar(
                    controller: _tabController,
                    padding: EdgeInsets.zero,
                    indicatorWeight: 0.1,
                    tabs: tabs
                        .map((e) => Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: e,
                    ))
                        .toList(),
                  ),
                ),
                if (Helpers.isTab(context)) Spacer(),
                IconButton(
                  onPressed:  () => Navigator.of(context)
                      .pushNamed(FilterScreen.routName),
                  icon: Icon(
                    IconlyLight.filter,
                    size: 25,
                  ),
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  ExploreHomePage(),
                  ExploreShopPage(),
                  ExploreSocialPage(),
                  if(!isKids)
                    ExploreKidsPage(),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
