import 'package:ezeness/logic/cubit/session_controller/session_controller_cubit.dart';
import 'package:ezeness/presentation/screens/profile/panel/widgets/currency_wallet_widget.dart';
import 'package:ezeness/res/app_res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../data/models/upgrade_store_plan/upgrade_store_plan.dart';
import '../../../data/models/user/user.dart';
import '../../../generated/l10n.dart';
import '../../../logic/cubit/app_config/app_config_cubit.dart';
import '../../widgets/common/common.dart';
import '../../widgets/common/components/common_text_widgets.dart';
import '../../widgets/common/components/elevated_option_button_with_subtitle.dart';
import '../../widgets/common/components/language_drop_down_menu.dart';
import '../profile/store_upgrade/store_upgrade_screen.dart';

class SettingScreen extends StatefulWidget {
  static const String routName = 'setting_screen';
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  late AppConfigCubit _appConfigCubit;
  late SessionControllerCubit _sessionControllerCubit;
  @override
  void initState() {
    _appConfigCubit = context.read<AppConfigCubit>();
    _sessionControllerCubit = context.read<SessionControllerCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    context.select<AppConfigCubit, User>((bloc) => bloc.state.user);
    User user = _appConfigCubit.getUser();
    UpgradeStorePlan? storePlan = user.store?.storePlan;
    bool isLoggedIn = _sessionControllerCubit.isLoggedIn();
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(title: Text(S.current.setting)),
      body: ListView(
        // ElevatedOptionWithPriceWidget(
        //   title: 'Business account',
        //   subTitle: 'BASIC PLAN',
        //   trailTitle: 'Free',
        //   index: 0,
        //   selectedPlan: _selectedPlan,
        //   onChanged: (value) {
        //     setState(() {
        //       _selectedPlan = value!;
        //     });
        //   },
        //   icon: SvgPicture.asset(
        //     Assets.assetsIconsStoreSolid,
        //     colorFilter:
        //     ColorFilter.mode(AppColors.greyTextColor, BlendMode.srcIn),
        //     height: size.height * .035,
        //     fit: BoxFit.cover,
        //   ),
        // ),
        // ElevatedOptionWithPriceWidget(
        //   title: 'Verification tag',
        //   subTitle: '36 Months plan',
        //   trailTitle: 'Free',
        //   index: 1,
        //   selectedPlan: _selectedPlan,
        //   onChanged: (value) {
        //     setState(() {
        //       _selectedPlan = value!;
        //     });
        //   },
        //   icon: Icon(
        //     Icons.verified,
        //     color: AppColors.secondary,
        //     size: size.width * .09,
        //   ),
        // ),
        children: [
          // ElevatedOptionWithSubtitleWidget(
          //   title: 'Default Currency',
          //   child: CurrencySelectorWidget(),
          //   icon: Icon(
          //     IconlyBold.wallet,
          //     color: Theme.of(context).brightness == Brightness.dark
          //         ? AppColors.whiteColor
          //         : AppColors.blackText,
          //     size: size.width * .09,
          //   ),
          // ),

          CurrencyWalletWidget(),

          ElevatedOptionWithSubtitleWidget(
            title: 'Language',
            child: LanguageDropDownMenuWidget(),
            icon: Icon(
              Icons.language,
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.whiteColor
                  : AppColors.blackText,
              size: size.width * .09,
            ),
          ),
          ElevatedOptionWithSubtitleWidget(
            title: S.current.theme,
            child: DropdownButton(
              underline: Container(),
              value: user.themeMood,
              icon: Icon(
                Icons.arrow_drop_down,
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.whiteColor
                    : AppColors.darkBlue,
              ),
              items: [
                DropdownMenuItem(
                  value: Constants.defaultSystemThemeKey,
                  child: RegularText14(S.current.systemDefault),
                ),
                DropdownMenuItem(
                  value: Constants.darkThemeKey,
                  child: RegularText14(S.current.darkTheme),
                ),
                DropdownMenuItem(
                  value: Constants.lightThemeKey,
                  child: RegularText14(S.current.lightTheme),
                ),
              ],
              onChanged: (String? v) {
                _appConfigCubit.setUser(user.copyWith(themeMood: v),
                    isEditTheme: true);
              },
            ),
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark
                  ? Icons.dark_mode
                  : Icons.light_mode_outlined,
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.whiteColor
                  : AppColors.blackText,
              size: size.width * .09,
            ),
          ),
          if (storePlan == null && isLoggedIn)
            Container(
              padding: EdgeInsets.all(12.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    S.current.upgradeToStore,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).primaryColorDark,
                          fontSize: 14.sp,
                        ),
                  ),
                  CustomOutlineButton(
                    borderColor: Colors.transparent,
                    hSize: 28.h,
                    wSize: 165.w,
                    onPressed: () {
                      Navigator.pushNamed(context, StoreUpgradeScreen.routName);
                    },
                    labelText: S.current.upgrade,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
