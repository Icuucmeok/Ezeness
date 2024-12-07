import 'package:ezeness/generated/l10n.dart';
import 'package:ezeness/logic/cubit/session_controller/session_controller_cubit.dart';
import 'package:ezeness/presentation/screens/profile/about/about_screen.dart';
import 'package:ezeness/presentation/widgets/common/common.dart';
import 'package:ezeness/presentation/widgets/common/components/country_drop_down_menu.dart';
import 'package:ezeness/presentation/widgets/common/components/currency_selector_widget.dart';
import 'package:ezeness/presentation/widgets/common/components/language_drop_down_menu.dart';
import 'package:ezeness/presentation/widgets/common/components/theme_drop_down_menu.dart';
import 'package:ezeness/res/app_res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconly/iconly.dart';

class GuestView extends StatelessWidget {
  const GuestView();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 30.w, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: 90,
                height: 35,
                child: Image.asset(
                  Theme.of(context).brightness == Brightness.dark
                      ? Assets.assetsImagesEzenessLogoDark
                      : Assets.assetsImagesEzenessLogoLight,
                ),
              ),
              Spacer(),
              SizedBox(
                width: 35,
                height: 35,
                child: Image.asset(
                  Theme.of(context).brightness == Brightness.dark
                      ? Assets.assetsImagesCircleLogoDark
                      : Assets.assetsImagesCircleLogo,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.darkColor
                  : AppColors.grey,
              borderRadius: BorderRadius.circular(20.r),
            ),
            margin: EdgeInsets.symmetric(vertical: 12),
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  S.current.welcomeToEzenessLife,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 15,
                      ),
                ),
                SizedBox(height: 10),
                Text(
                  S.current.firstSocialBusinessMediaApp,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 15,
                      ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.darkColor
                  : AppColors.grey,
              borderRadius: BorderRadius.circular(20.r),
            ),
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Text(
              S.current.ezenessCreatesOpportunities,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 15,
                  ),
            ),
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.darkColor
                  : AppColors.grey,
              borderRadius: BorderRadius.circular(20.r),
            ),
            margin: EdgeInsets.symmetric(vertical: 12),
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  S.current.dontWaitOpenBusiness,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 15,
                      ),
                ),
                SizedBox(height: 10),
                CustomElevatedButton(
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: 50,
                  backgroundColor: AppColors.secondary,
                  onPressed: () {
                    context.read<SessionControllerCubit>().goToSigInScreen();
                  },
                  withBorderRadius: true,
                  child: Text(S.current.loginSignup,
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          fontSize: 16, color: AppColors.whiteColor)),
                ),
              ],
            ),
          ),
          SizedBox(height: 15),

          // theme
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
            child: Row(
              children: [
                Icon(
                  Icons.color_lens,
                  size: 30,
                ),
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
          Divider(),
          // Language
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
            child: Row(
              children: [
                Icon(
                  Icons.language,
                  size: 30,
                ),
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
          Divider(),
          // Currency
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
            child: Row(
              children: [
                Icon(
                  IconlyBold.wallet,
                  size: 30,
                ),
                SizedBox(width: 15),
                Text(
                  S.current.currency,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontSize: 15),
                ),
                Spacer(),
                CurrencySelectorWidget(
                  alignment: AlignmentDirectional.centerEnd,
                ),
              ],
            ),
          ),
          Divider(),
          // Country
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
            child: Row(
              children: [
                Icon(
                  Icons.flag,
                  size: 30,
                ),
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

          Divider(),

          ListTile(
            leading: Icon(
              Icons.info_outline,
              size: 30,
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
        ],
      ),
    );
  }
}
