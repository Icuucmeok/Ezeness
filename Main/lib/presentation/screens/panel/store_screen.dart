import 'package:ezeness/presentation/widgets/common/common.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../logic/cubit/session_controller/session_controller_cubit.dart';
import '../../widgets/panel_setting_container_widget.dart';
import '../../widgets/panel_setting_notification_widget.dart';


class StoreScreen extends StatefulWidget {
  const StoreScreen({Key? key}) : super(key: key);

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    bool isLoggedIn=context.read<SessionControllerCubit>().isLoggedIn();
    return SafeArea(
      child:isLoggedIn? Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              PanelSettingContainerWidget(
                headerIcon: CupertinoIcons.bag,
                headerTitle: "Orders",
                headerWidget: null,
                widget: Column(
                  children: [
                    PanelSettingNotificationWidget(
                      onTap: () {},
                      notificationText: "New Orders",
                      notificationCount: "1",
                      notificationTextColor:Theme.of(context).primaryColorDark,

                    ),
                    PanelSettingNotificationWidget(
                      onTap: () {},
                      notificationText: "Order in process",
                      notificationCount: "0",
                    ),
                    PanelSettingNotificationWidget(
                      onTap: () {},
                      notificationText: "Ready orders",
                      notificationCount: "0",
                    ),
                    PanelSettingNotificationWidget(
                      onTap: () {},
                      notificationText: "On delivery orders",
                      notificationCount: "0",
                    ),
                    PanelSettingNotificationWidget(
                      onTap: () {},
                      notificationText: "Delivered orders",
                      notificationCount: "0",
                    ),
                  ],
                ),
              ),
              PanelSettingContainerWidget(
                headerIcon: CupertinoIcons.bag,
                headerTitle: "Refunds",
                widget: Column(
                  children: [
                    PanelSettingNotificationWidget(
                      onTap: () {},
                      notificationText: "Refund request",
                      notificationCount: "0",
                    ),
                    PanelSettingNotificationWidget(
                      onTap: () {},
                      notificationText: "Refund pickup",
                      notificationCount: "0",
                    ),
                    PanelSettingNotificationWidget(
                      onTap: () {},
                      notificationText: "Refunded",
                      notificationCount: "0",
                    ),
                  ],
                ),
                headerWidget: null,
              ),
              PanelSettingContainerWidget(
                headerIcon:CupertinoIcons.bag,
                headerTitle: "Cancellation",
                headerWidget: null,
                widget: Column(
                  children: [
                    PanelSettingNotificationWidget(
                      onTap: () {},
                      notificationText: "Canceled order",
                      notificationCount: "0",
                    ),
                    PanelSettingNotificationWidget(
                      onTap: () {},
                      notificationText: "Rejected orders",
                      notificationCount: "0",
                    ),
                    PanelSettingNotificationWidget(
                      onTap: () {},
                      notificationText: "Refunded",
                      notificationCount: "0",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ):const GuestCard(),
    );
  }
}
