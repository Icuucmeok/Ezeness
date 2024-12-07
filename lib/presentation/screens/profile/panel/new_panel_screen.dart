import 'package:ezeness/presentation/screens/profile/panel/wallet_tap_screen.dart';
import 'package:ezeness/presentation/widgets/common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconly/iconly.dart';

import '../../../../logic/cubit/session_controller/session_controller_cubit.dart';

class NewPanelScreen extends StatefulWidget {
  static const String routName = 'new_panel_screen';

  @override
  _NewPanelScreenState createState() => _NewPanelScreenState();
}

class _NewPanelScreenState extends State<NewPanelScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 1, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = context.read<SessionControllerCubit>().isLoggedIn();
    return SafeArea(
      child: isLoggedIn
          ? Scaffold(
        appBar: AppBar(
          leadingWidth: double.infinity,
          elevation: 0,
          leading: Row(
            children: [
              15.horizontalSpace,
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                    IconlyLight.wallet,
                  size: 30.r,
                  ),
              ),

            ],
          ),
        ),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          controller: _tabController,
          children: [
            WalletTapScreen(),
          ],
        ),
      ):Scaffold(body: GuestCard()),
    );
  }


}


