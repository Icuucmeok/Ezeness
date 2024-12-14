import 'package:collection/collection.dart';
import 'package:ezeness/data/models/invite_credit/invite_credit.dart';
import 'package:ezeness/data/models/user/user.dart';
import 'package:ezeness/data/utils/error_handler.dart';
import 'package:ezeness/generated/l10n.dart';
import 'package:ezeness/logic/cubit/app_config/app_config_cubit.dart';
import 'package:ezeness/logic/cubit/invite_user/invite_user_cubit.dart';
import 'package:ezeness/presentation/screens/profile/invite_users/special/special_invites_list_screen.dart';
import 'package:ezeness/presentation/screens/profile/invite_users/stander/stander_invites_list_screen.dart';
import 'package:ezeness/presentation/screens/profile/invite_users/widgets/invite_credit_widget.dart';
import 'package:ezeness/presentation/widgets/common/common.dart';
import 'package:ezeness/presentation/widgets/pull_to_refresh.dart';
import 'package:ezeness/res/app_res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconly/iconly.dart';

import 'pro/pro_invites_list_screen.dart';

class InviteUsersScreen extends StatefulWidget {
  static const String routName = 'invite_users_screen';

  const InviteUsersScreen({Key? key}) : super(key: key);

  @override
  State<InviteUsersScreen> createState() => _InviteUsersScreenState();
}

class _InviteUsersScreenState extends State<InviteUsersScreen> {
  late InviteUserCubit _inviteUserCubit;
  late User user;
  late bool isAdmin;

  @override
  void initState() {
    _inviteUserCubit = context.read<InviteUserCubit>();
    _inviteUserCubit.getInvitationCredit();

    user = context.read<AppConfigCubit>().getUser();
    isAdmin = user.role == Constants.superAdminRoleKey ||
        user.role == Constants.adminRoleKey;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(S.current.inviteUsers),
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          children: [
            // Headers
            Stack(
              alignment: Alignment.bottomCenter,
              clipBehavior: Clip.none,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.darkColor
                        : AppColors.greyCard,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  padding:
                      EdgeInsets.only(left: 10, right: 10, top: 12, bottom: 50),
                  child: Text(
                    S.current.inviteFriendsAndFamily,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                Positioned(
                    bottom: -30,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? AppColors.darkColor
                            : AppColors.greyCard,
                        border: Border.all(
                          color: AppColors.primaryColor,
                        ),
                        shape: BoxShape.circle,
                      ),
                      padding: EdgeInsets.all(14),
                      child: Icon(
                        IconlyBold.ticket_star,
                        color: AppColors.gold,
                        size: 35,
                      ),
                    ))
              ],
            ),
            SizedBox(height: 50),

            // Call invitations Api
            Expanded(
              child: BlocBuilder<InviteUserCubit, InviteUserState>(
                bloc: _inviteUserCubit,
                builder: (context, state) {
                  if (state is InviteUserLoading) {
                    return const CenteredCircularProgressIndicator();
                  }
                  if (state is InvitationCreditLoaded) {
                    InviteCredit? specialInvite = state
                        .response.inviteCreditList!
                        .firstWhereOrNull((element) =>
                            element.type == Constants.specialInviteKey);
                    InviteCredit? standerInvite = state
                        .response.inviteCreditList!
                        .firstWhereOrNull((element) =>
                            element.type == Constants.standardInviteKey);

                    return PullToRefresh(
                      onRefresh: () {
                        _inviteUserCubit.getInvitationCredit();
                      },
                      child: ListView(
                        children: [
                          // View Pro Invite Widget
                          InviteCreditWidget(
                            inviteCredit: state.response.proCried,
                            type: InviteType.pro,
                            onTap: () => Navigator.of(context)
                                .pushNamed(ProInvitesListScreen.routName),
                          ),

                          // View stander Invite Widget
                          if (standerInvite != null || isAdmin)
                            SizedBox(height: 15),
                          if (standerInvite != null || isAdmin)
                            InviteCreditWidget(
                              inviteCredit: standerInvite!,
                              type: InviteType.stander,
                              onTap: () => Navigator.of(context)
                                  .pushNamed(StanderInvitesListScreen.routName),
                            ),

                          // View Special Invite Widget
                          if (specialInvite != null || isAdmin)
                            SizedBox(height: 15),
                          if (specialInvite != null || isAdmin)
                            InviteCreditWidget(
                              inviteCredit: specialInvite!,
                              type: InviteType.special,
                              onTap: () => Navigator.of(context)
                                  .pushNamed(SpecialInvitesListScreen.routName),
                            ),
                        ],
                      ),
                    );
                  }
                  if (state is InviteUserFailure) {
                    return ErrorHandler(exception: state.exception)
                        .buildErrorWidget(
                      context: context,
                      retryCallback: () =>
                          _inviteUserCubit.getInvitationCredit(),
                    );
                  }
                  return Container();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
