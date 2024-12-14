import 'package:ezeness/logic/cubit/notification/notification_cubit.dart';
import 'package:ezeness/presentation/screens/auth/auth_screen.dart';
import 'package:ezeness/presentation/screens/get_user_location_screen.dart';
import 'package:ezeness/presentation/screens/home/home_screen.dart';
import 'package:ezeness/presentation/screens/select_app_country_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../res/app_res.dart';
import '../../logic/cubit/app_config/app_config_cubit.dart';
import '../../logic/cubit/session_controller/session_controller_cubit.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  static const String routName = 'splash_screen';
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late SessionControllerCubit _sessionControllerCubit;
  late NotificationCubit _notificationCubit;
  late bool isLoggedIn;
  @override
  void initState() {
    isLoggedIn = context.read<SessionControllerCubit>().isLoggedIn();
    _sessionControllerCubit = context.read<SessionControllerCubit>();
    _notificationCubit = context.read<NotificationCubit>();
    getData();
    super.initState();
  }

  getData() async {
    await _sessionControllerCubit.getAppConfig();
    _notificationCubit.zeroTotalUnSeenNumber();
    if (isLoggedIn) _notificationCubit.getNotificationsLists();
    if(_sessionControllerCubit.getAppCountry()==null){
      Navigator.of(context).pushReplacementNamed(SelectAppCountryScreen.routName);
    }else if(_sessionControllerCubit.getUserLocation()==null){
      Navigator.of(context).pushReplacementNamed(GetUserLocationScreen.routName);
    }else if(context.read<AppConfigCubit>().getIsFirstLaunch()){
      Navigator.of(context).pushReplacementNamed(OnboardingScreen.routName);
    }else if (isLoggedIn) {
      Navigator.of(context).pushReplacementNamed(HomeScreen.routName);
    } else {
      Navigator.of(context).pushReplacementNamed(AuthScreen.routName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: [
          Positioned(
            width: 200.w,
            height: 200.h,
            child: Image.asset(
              Assets.assetsImagesCircleLogo,
              width: 200.w,
              height: 200.h,
            ),
          ),
          Positioned(
            bottom: 20,
            width: 120.w,
            height: 120.h,
            child: Image.asset(
              Theme.of(context).brightness == Brightness.dark
                  ? Assets.assetsImagesEzenessLogoDark
                  : Assets.assetsImagesEzenessLogoLight,
              width: 120.w,
              height: 120.h,
            ),
          ),
          Positioned(
              bottom: 20,
              child: Text(
                "SOCIAL BUSINESS MEDIA\nAll rights reserved",
                textAlign: TextAlign.center,
                // style: Theme.of(context).textTheme.bodyLarge,
              )),
        ],
      ),
    );
  }
}
