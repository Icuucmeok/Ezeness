
import 'package:ezeness/logic/cubit/notification/notification_cubit.dart';
import 'package:ezeness/presentation/screens/panel/notification_by_type_screen.dart';
import 'package:ezeness/presentation/screens/panel/wallet_screen/wallet_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/user/user.dart';
import '../../../logic/cubit/app_config/app_config_cubit.dart';
import '../../../logic/cubit/session_controller/session_controller_cubit.dart';
import '../../../res/app_res.dart';
import '../../widgets/child_lock_widget.dart';

class PanelScreen extends StatefulWidget {
  static const String routName = 'panel_screen';
  const PanelScreen({Key? key}) : super(key: key);

  @override
  State<PanelScreen> createState() => _PanelScreenState();
}

class _PanelScreenState extends State<PanelScreen>
    with TickerProviderStateMixin {
  late SessionControllerCubit _sessionControllerCubit;
  bool isStoreHasOrders = false;
  @override
  void initState() {
    _sessionControllerCubit = context.read<SessionControllerCubit>();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    User user = context.read<AppConfigCubit>().getUser();
    if (user.store != null) {
      isStoreHasOrders = user.store!.storePlan!.id == Constants.planSKey ||
          user.store!.storePlan!.id == Constants.plan24Key;
    }
    List<Widget> tabs = [
      //FIRST VERSION EDITS
      // if(isStoreHasOrders)
      // Tab(
      //   child: Icon(Icons.storefront_outlined),
      // ),
      Tab(
        child: Icon(Icons.wallet),
      ),
      //FIRST VERSION EDITS
      // Tab(
      //   child: Icon(CupertinoIcons.cart),
      // ),
      Tab(
        child: Builder(builder: (context) {
          int totalUnSeenNumber =
              BlocProvider.of<NotificationCubit>(context, listen: true)
                  .totalUnSeenNumber;
          return Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(CupertinoIcons.bell),
              if (totalUnSeenNumber != 0)
                Positioned(
                  top: -2,
                  right: -2,
                  child: CircleAvatar(
                      radius: 8,
                      backgroundColor: Colors.red,
                      child: FittedBox(
                          child: Text(
                              totalUnSeenNumber > 99
                                  ? "+99"
                                  : totalUnSeenNumber.toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                      color: Colors.white, fontSize: 10)))),
                ),
            ],
          );
        }),
      ),
    ];

    TabController _tabController =
        TabController(length: tabs.length, vsync: this);

    context
        .read<AppConfigCubit>()
        .setPanelScreenOnTapLogo(() => _tabController.animateTo(
              0,
              curve: Curves.easeIn,
              duration: const Duration(milliseconds: 200),
            ));

    return Scaffold(
      body: SafeArea(
        child: _sessionControllerCubit.getIsKids() == 1
            ? ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ChildLockWidget(),
                  ),
                ],
              )
            : DefaultTabController(
                length: tabs.length,
                child: Column(
                  children: [
                    TabBar(
                      indicator: BoxDecoration(
                        color: Colors.grey.withOpacity(0.2),
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(20.0),
                          bottomLeft: Radius.circular(20.0),
                        ),
                      ),
                      controller: _tabController,
                      tabs: tabs,
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          //FIRST VERSION EDITS
                          // if(isStoreHasOrders)
                          // StoreScreen(),
                          WalletScreen(),
                          //FIRST VERSION EDITS
                          // OrderScreen(),
                          NotificationByTypeScreen(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
