import 'package:ezeness/presentation/screens/explore/explore_users_screen.dart';
import 'package:ezeness/presentation/widgets/profile_widget.dart';
import 'package:flutter/material.dart';

import '../../../../data/models/user/user.dart';
import '../../../../generated/l10n.dart';
import '../../../router/app_router.dart';
import '../../../widgets/common/common.dart';

class ExploreUsers extends StatefulWidget {
  final List<User> usersList;

  const ExploreUsers({required this.usersList, Key? key}) : super(key: key);

  @override
  State<ExploreUsers> createState() => _ExploreUsersState();
}

class _ExploreUsersState extends State<ExploreUsers> {
  @override
  Widget build(BuildContext context) {
    return widget.usersList.isEmpty
        ? SizedBox()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ViewAllIconHeader(
                  leadingText: S.current.connect,
                  onNavigate: () {
                    Navigator.of(AppRouter.mainContext)
                        .pushNamed(ExploreUsersScreen.routName);
                  }),
              SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: widget.usersList
                      .map(
                          (e) => ProfileWidget(user: e, withFollowButton: true))
                      .toList(),
                ),
              ),
            ],
          );
  }
}
