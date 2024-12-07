import 'package:ezeness/presentation/screens/auth/auth_screen.dart';
import 'package:ezeness/presentation/utils/app_modal_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/models/user/user.dart';
import '../../generated/l10n.dart';
import '../../logic/cubit/app_config/app_config_cubit.dart';
import '../../res/app_res.dart';
import '../services/fcm_service.dart';
import '../utils/helpers.dart';
import '../widgets/common/common.dart';

class OnboardingScreen extends StatefulWidget {
  static const String routName = 'onboarding_screen';
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  late AppConfigCubit _appConfigCubit;
  int _currentPage = 0;
  void nextPage() {
    _pageController.nextPage(
        duration: const Duration(milliseconds: 500), curve: Curves.linear);
  }

  void previousPage() {
    _pageController.previousPage(
        duration: const Duration(milliseconds: 500), curve: Curves.linear);
  }

  @override
  void initState() {
    _appConfigCubit = context.read<AppConfigCubit>();
    FcmService.fcmRequestPermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    context.select<AppConfigCubit, User>((bloc) => bloc.state.user);
    List<Widget> pages = [
      Container(
        margin: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 50.h),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Image.asset(
                Assets.assetsImagesCircleLogo,
                width: 200.w,
                height: 200.h,
              ),
            ),
            SizedBox(height: 50.h),
            GestureDetector(
              onTap: () {
                AppModalBottomSheet.showMainModalBottomSheet(
                    height: 200,
                    context: context,
                    scrollableContent: ListView(
                      children: [
                        buildLanguageCard(title: "English US", languageCode: "en"),
                        buildLanguageCard(title: "العربية AR", languageCode: "ar"),
                        buildLanguageCard(title: "FA فارسى", languageCode: "fa"),
                      ],
                    ));
              },
              child: Text(
                  Helpers.getLanguageNameFromCode(
                          Helpers.getLanguageCode(context)) +
                      " ▼ ",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        letterSpacing: 1,
                        fontSize: 14.sp,
                      )),
            ),
            Expanded(child: SizedBox()),
            Image.asset(
              Theme.of(context).brightness == Brightness.dark
                  ? Assets.assetsImagesEzenessLogoDark
                  : Assets.assetsImagesEzenessLogoLight,
              width: 120.w,
              height: 120.h,
            ),
            SizedBox(height: 50.h),
          ],
        ),
      ),
      // Container(
      //   margin: EdgeInsets.all(20.w),
      //   child: Column(
      //     crossAxisAlignment: CrossAxisAlignment.center,
      //     children: [
      //       SizedBox(height: 20.h),
      //       Container(
      //         width: MediaQuery.of(context).size.width,
      //         child: Image.asset(
      //           AppImages.circleLogo,
      //           width: 200.w,
      //           height: 200.h,
      //         ),
      //       ),
      //       SizedBox(height: 20.h),
      //       Container(
      //         child: Logo(),
      //         alignment: Alignment.center,
      //       ),
      //       SizedBox(height: 50.h),
      //       GestureDetector(
      //         onTap: (){
      //           AppModalBottomSheet.showMainModalBottomSheet(
      //               height: 200,
      //               context: context,
      //               scrollableContent: ListView(
      //                 children: [
      //                   buildThemeCard(themeMood: Constants.defaultSystemThemeKey, user: user),
      //                   buildThemeCard(themeMood: Constants.darkThemeKey, user: user),
      //                   buildThemeCard(themeMood: Constants.lightThemeKey, user: user),
      //                 ],
      //               ));
      //         },
      //         child: Text((user.getUserThemeName())+" ▼ ",style: Theme.of(context).textTheme.bodyLarge?.copyWith(
      //           letterSpacing: 1,
      //           fontSize: 14.sp,
      //         )),
      //       ),
      //     ],
      //   ),
      // ),
    ];
    return SafeArea(
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Scaffold(
            body: Stack(
          children: [
            PageView(
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              controller: _pageController,
              children: pages,
            ),
            Positioned(
              bottom: 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    _currentPage > 0
                        ? CustomElevatedButton(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        withBorderRadius: true,
                        borderColor: AppColors.dividerColor,
                        onPressed: previousPage,
                        child: Text(S.current.back))
                        : SizedBox(),
                    _currentPage < pages.length - 1
                        ? CustomElevatedButton(
                        margin: EdgeInsets.symmetric(horizontal: 20,vertical: 4),
                        backgroundColor: AppColors.primaryColor,
                        withBorderRadius: true,
                        onPressed: nextPage, child: Text(S.current.next,style: TextStyle(color: Colors.white)))
                        : CustomElevatedButton(
                        backgroundColor: AppColors.primaryColor,
                        margin: EdgeInsets.symmetric(horizontal: 20,vertical: 4),
                        withBorderRadius: true,
                        onPressed: () {
                          _appConfigCubit.setFirstLaunchToFalse();
                          Navigator.of(context)
                              .pushReplacementNamed(AuthScreen.routName);
                        },
                        child: Text(S.current.done,style: TextStyle(color: Colors.white))),
                  ],
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }

  buildLanguageCard({required String languageCode, required String title}) {
    return ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 25),
        title: Text(title,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: 16,
                  fontFamily: "Poppins",
                )),
        onTap: () {
          Navigator.of(context).pop();
          _appConfigCubit.setLocale(languageCode);
        });
  }

  buildThemeCard({required String themeMood, required User user}) {
    return ListTile(
      title: Text(themeMood),
      onTap: () {
        Navigator.of(context).pop();
        _appConfigCubit.setUser(user.copyWith(themeMood: themeMood),
            isEditTheme: true);
      },
    );
  }
}
