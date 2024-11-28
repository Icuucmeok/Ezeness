import 'dart:io' show Platform;

import 'package:ezeness/logic/cubit/notification/notification_cubit.dart';
import 'package:ezeness/presentation/screens/auth/sign_in_screen.dart';
import 'package:ezeness/presentation/screens/auth/sign_up/sign_up_screen.dart';
import 'package:ezeness/presentation/screens/home/home_screen.dart';
import 'package:ezeness/presentation/widgets/common/components/language_drop_down_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../data/utils/error_handler.dart';
import '../../../generated/l10n.dart';
import '../../../logic/cubit/session_controller/session_controller_cubit.dart';
import '../../../res/app_res.dart';
import '../../widgets/common/common.dart';
import '../../widgets/google_signin_button.dart';

class AuthScreen extends StatefulWidget {
  static const String routName = 'auth_screen';

  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late SessionControllerCubit _sessionControllerCubit;
  @override
  void initState() {
    _sessionControllerCubit = context.read<SessionControllerCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Container(
            width: 90,
            height: 35,
            margin: EdgeInsets.symmetric(horizontal: 15),
            child: Image.asset(
              Theme.of(context).brightness == Brightness.dark
                  ? Assets.assetsImagesEzenessLogoDark
                  : Assets.assetsImagesEzenessLogoLight,
            ),
          ),
        ],
      ),
      body: BlocConsumer<SessionControllerCubit, SessionControllerState>(
          bloc: _sessionControllerCubit,
          listener: (context, state) {
            if (state is SessionControllerSocialSignedIn) {
              if (state.response.user!.isSocialRegister) {
                Navigator.of(context).pushReplacementNamed(
                    SignUpScreen.routName,
                    arguments: {"user": state.response.user});
              } else {
                context.read<NotificationCubit>().getNotificationsLists();
                Navigator.of(context).pushReplacementNamed(HomeScreen.routName);
              }
            }
            if (state is SessionControllerError) {
              ErrorHandler(exception: state.exception)
                  .showErrorSnackBar(context: context);
            }
          },
          builder: (context, state) {
            return ListView(
              physics: const NeverScrollableScrollPhysics(),
              children: [
                SizedBox(height: 35.h),
                Image.asset(
                  Assets.assetsImagesCircleLogo,
                  width: 135,
                  height: 135,
                ),
                // Center(child: const Logo()),
                SizedBox(height: 35.h),
                CustomElevatedButton(
                  margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  backgroundColor: AppColors.secondary,
                  withBorderRadius: true,
                  onPressed: () {
                    Navigator.pushNamed(context, SignInScreen.routName);
                  },
                  child: Text(S.current.signIn,
                      style: TextStyle(color: Colors.white)),
                ),
                SizedBox(height: 15.h),

                if (Platform.isIOS && AppData.isShowGoogleButton)
                  GoogleSignInButton(),
                if (Platform.isAndroid) GoogleSignInButton(),
                // if(Platform.isIOS)
                //   AppleSignInButton(),
                CustomElevatedButton(
                  margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  withBorderRadius: true,
                  borderColor: AppColors.dividerColor,
                  onPressed: () {
                    Navigator.pushNamed(context, SignUpScreen.routName);
                  },
                  child: Text(S.current.createAccount),
                ),
                CustomElevatedButton(
                  margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  withBorderRadius: true,
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                        context, HomeScreen.routName);
                  },
                  borderColor: AppColors.dividerColor,
                  child: Text(S.current.continueAsGuest),
                ),

                SizedBox(height: 25.h),

                Center(child: LanguageDropDownMenuWidget()),
              ],
            );
          }),
    );
  }
}
