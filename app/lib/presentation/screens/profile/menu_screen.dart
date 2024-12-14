import 'package:ezeness/presentation/screens/profile/about/about_screen.dart';
import 'package:ezeness/presentation/screens/profile/bookmark_screen.dart';
import 'package:ezeness/presentation/screens/profile/invite_users/invite_users_screen.dart';
import 'package:ezeness/presentation/screens/profile/privacy_security/privacy_security_screen.dart';
import 'package:ezeness/presentation/screens/profile/store_upgrade/store_upgrade_screen.dart';
import 'package:ezeness/presentation/screens/profile/username_upgrade/username_upgrade_screen.dart';
import 'package:ezeness/presentation/utils/app_dialog.dart';
import 'package:ezeness/presentation/utils/date_handler.dart';
import 'package:ezeness/presentation/widgets/common/components/country_drop_down_menu.dart';
import 'package:ezeness/presentation/widgets/common/components/language_drop_down_menu.dart';
import 'package:ezeness/presentation/widgets/common/components/theme_drop_down_menu.dart';
import 'package:ezeness/res/app_res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';

import '../../../data/models/upgrade_store_plan/upgrade_store_plan.dart';
import '../../../data/models/user/user.dart';
import '../../../generated/l10n.dart';
import '../../../logic/cubit/app_config/app_config_cubit.dart';
import '../../../logic/cubit/profile/profile_cubit.dart';
import '../../../logic/cubit/session_controller/session_controller_cubit.dart';
import 'blocked_user_screen.dart';
import 'edit_profile_screen/edit_profile_screen.dart';

class MenuScreen extends StatelessWidget {
  static const String routName = 'menu_screen';
  const MenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User user = context.read<AppConfigCubit>().getUser();
    UpgradeStorePlan? storePlan = user.store?.storePlan;
    bool isKids = context.read<SessionControllerCubit>().getIsKids() == 1;
    return Scaffold(
      appBar: AppBar(title: Text(S.current.menu)),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (!isKids) ...{
              ///INVITE PEOPLE
              ListTile(
                leading: Icon(
                  size: 30,
                  IconlyBold.ticket_star,
                  color: AppColors.gold,
                ),
                title: Text(
                  S.current.inviteAndGetPaid,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).primaryColorDark,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                onTap: () {
                  Navigator.pushNamed(context, InviteUsersScreen.routName);
                },
              ),
              _buildDivider(context),
              ListTile(
                leading: Icon(
                  size: 30,
                  IconlyLight.edit_square,
                  color: Theme.of(context).primaryColorDark,
                ),
                title: Text(
                  S.current.editProfile,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).primaryColorDark,
                        fontSize: 15,
                      ),
                ),
                onTap: () {
                  Navigator.of(context)
                      .pushNamed(EditProfileScreen.routName)
                      .then((value) {
                    context
                        .read<ProfileCubit>()
                        .getMyProfile(context.read<AppConfigCubit>());
                  });
                },
              ),
              ListTile(
                leading: Icon(
                  size: 30,
                  IconlyLight.lock,
                  color: Theme.of(context).primaryColorDark,
                ),
                title: Text(
                  S.current.privacyAndSecurity,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).primaryColorDark,
                        fontSize: 15,
                      ),
                ),
                onTap: () {
                  Navigator.of(context)
                      .pushNamed(PrivacySecurityScreen.routName);
                },
              ),
              _buildDivider(context),

              ListTile(
                leading: Icon(
                  size: 30,
                  Icons.block,
                  color: Theme.of(context).primaryColorDark,
                ),
                title: Text(
                  S.current.blockedUsers,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).primaryColorDark,
                        fontSize: 15,
                      ),
                ),
                onTap: () =>
                    Navigator.pushNamed(context, BlockedUserScreen.routName),
              ),
              ListTile(
                leading: Icon(
                  size: 30,
                  Icons.info_outline,
                  color: Theme.of(context).primaryColorDark,
                ),
                title: Text(
                  S.current.about,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).primaryColorDark,
                        fontSize: 15,
                      ),
                ),
                onTap: () {
                  Navigator.pushNamed(context, AboutScreen.routName);
                },
              ),
              ListTile(
                leading: Icon(
                  size: 30,
                  IconlyBold.bookmark,
                  color: Theme.of(context).primaryColorDark,
                ),
                title: Text(
                  S.current.saved,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).primaryColorDark,
                        fontSize: 15,
                      ),
                ),
                onTap: () {
                  Navigator.pushNamed(context, BookmarkScreen.routName);
                },
              ),
              _buildDivider(context),
              BlocBuilder<SessionControllerCubit, SessionControllerState>(
                builder: (context, state) {
                  return ListTile(
                    leading: Icon(
                      size: 30,
                      IconlyBold.logout,
                      color: Theme.of(context).primaryColorDark,
                    ),
                    title: Text(
                      S.current.logout,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).primaryColorDark,
                            fontSize: 15,
                          ),
                    ),
                    onTap: state is SessionControllerLoading
                        ? null
                        : () async {
                            context
                                .read<SessionControllerCubit>()
                                .signOut(context.read<AppConfigCubit>());
                          },
                  );
                },
              ),
              _buildDivider(context),
            },
            // Language
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
              child: Row(
                children: [
                  Icon(size: 30, Icons.language),
                  SizedBox(width: 15),
                  Text(
                    S.current.language,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontSize: 15),
                  ),
                  Spacer(),
                  LanguageDropDownMenuWidget(),
                ],
              ),
            ),

            // theme
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
              child: Row(
                children: [
                  Icon(size: 30, Icons.color_lens),
                  SizedBox(width: 15),
                  Text(
                    S.current.theme,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontSize: 15),
                  ),
                  Spacer(),
                  ThemeDropDownMenuWidget(),
                ],
              ),
            ),

            // Country
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
              child: Row(
                children: [
                  Icon(size: 30, Icons.flag),
                  SizedBox(width: 15),
                  Text(
                    S.current.country,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontSize: 15),
                  ),
                  Spacer(),
                  CountryDropDownMenuWidget(),
                ],
              ),
            ),

            _buildDivider(context),

            if (!isKids) ...{
              Container(
                margin: EdgeInsets.all(0.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ///UPGRADE TO STORE
                    ListTile(
                      title: Text(S.current.accountType),
                      subtitle: Text(
                        user.store != null &&
                                user.store!.subscriptionEndDate != null
                            ? "${storePlan?.name.toString()} " +
                                S.current.until +
                                ": " +
                                DateHandler(user.store!.subscriptionEndDate
                                        .toString())
                                    .getDate()
                            : S.current.upgradeAccountType,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontSize: 13.5,
                              color: Theme.of(context)
                                  .primaryColorDark
                                  .withOpacity(0.5),
                            ),
                      ),
                      leading: Icon(
                          size: 30,
                          Icons.storefront_rounded,
                          color: AppColors.secondary),
                      trailing: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(
                              context, StoreUpgradeScreen.routName,
                              arguments: storePlan == null
                                  ? null
                                  : {"isEditPlan": true});
                        },
                        child: Text(storePlan == null
                            ? S.current.upgrade
                            : S.current.edit + " " + S.current.plan),
                      ),
                    ),
                    _buildDivider(context),

                    ///UPGRADE PROFILE
                    ListTile(
                      title: Text(
                        S.current.verificationTag,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context).primaryColorDark,
                              fontSize: 15,
                            ),
                      ),
                      subtitle: Text(
                        user.usernamePlan != null
                            ? S.current.until +
                                ": " +
                                DateHandler(
                                        user.usernamePlan!.endDate.toString())
                                    .getDate()
                            : S.current.getTopProfileUsername,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontSize: 13.5,
                              color: Theme.of(context)
                                  .primaryColorDark
                                  .withOpacity(0.5),
                            ),
                      ),
                      leading: Icon(
                          size: 30, Icons.verified, color: AppColors.secondary),
                      trailing: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(
                              context, UserNameUpgradeScreen.routName);
                        },
                        child: Text(user.usernamePlan == null
                            ? S.current.upgrade
                            : S.current.edit + " " + S.current.plan),
                      ),
                    ),
                  ],
                ),
              ),
              _buildDivider(context),
            },
            if (!isKids) ...{
              ListTile(
                leading: Icon(
                  size: 30,
                  IconlyBold.delete,
                  color: Colors.grey.shade600,
                ),
                title: Text(
                  S.current.deleteAccount,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.grey.shade600,
                        fontSize: 15,
                      ),
                ),
                onTap: () {
                  AppDialog.showDeleteAccountDialog(context: context);
                },
              ),
              _buildDivider(context),
            }
          ],
        ),
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Divider(
      endIndent: 8,
      indent: 8,
      thickness: 1.5,
      color: Theme.of(context).brightness == Brightness.dark
          ? AppColors.grey900
          : AppColors.greyDark,
    );
  }
}
