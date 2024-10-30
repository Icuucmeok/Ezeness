import 'dart:convert';

import 'package:ezeness/data/models/auth/login_body.dart';
import 'package:ezeness/logic/cubit/notification/notification_cubit.dart';
import 'package:ezeness/logic/cubit/session_controller/session_controller_cubit.dart';
import 'package:ezeness/presentation/screens/auth/reset_password/reset_password_screen.dart';
import 'package:ezeness/presentation/screens/auth/sign_up/sign_up_screen.dart';
import 'package:ezeness/presentation/screens/home/home_screen.dart';
import 'package:ezeness/presentation/services/fcm_service.dart';
import 'package:ezeness/presentation/utils/text_input_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/utils/error_handler.dart';
import '../../../generated/l10n.dart';
import '../../../res/app_res.dart';
import '../../widgets/common/common.dart';

class SignInScreen extends StatefulWidget {
  static const String routName = 'sign_in_screen';

  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool isSignUpWithEmail = true;
  bool _rememberMe = false;
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPhone = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _countryCodeController = TextEditingController();
  final _keyForm = GlobalKey<FormState>();
  late SessionControllerCubit _sessionControllerCubit;
  late SharedPreferences prefs;

  getSavedSignInCredentials() async {
    prefs = await SharedPreferences.getInstance();
    String? json = prefs.getString(Constants.savedSignInCredentials);
    if (json != null) {
      LoginBody tempBody = LoginBody.fromJson(jsonDecode(json));
      if (tempBody.phoneNumber != null) {
        _controllerPhone.text = tempBody.phoneNumber!;
      }
      if (tempBody.email != null) {
        _controllerEmail.text = tempBody.email!;
      }
      if (tempBody.password != null) {
        _controllerPassword.text = tempBody.password!;
      }
      if (tempBody.codeNumber != null) {
        _countryCodeController.text = tempBody.codeNumber!;
      }
    }
  }

  @override
  void initState() {
    _sessionControllerCubit = context.read<SessionControllerCubit>();
    getSavedSignInCredentials();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.current.signIn,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColorDark.withOpacity(0.7),
                fontSize: 16,
              ),
        ),
        actions: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: 90,
              height: 30,
              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Image.asset(
                Theme.of(context).brightness == Brightness.dark
                    ? Assets.assetsImagesEzenessLogoDark
                    : Assets.assetsImagesEzenessLogoLight,
              ),
            ),
          ),
        ],
      ),
      body: BlocConsumer<SessionControllerCubit, SessionControllerState>(
        bloc: _sessionControllerCubit,
        listener: (context, state) {
          if (state is SessionControllerSignedIn) {
            context.read<NotificationCubit>().getNotificationsLists();
            Navigator.of(context).pushReplacementNamed(HomeScreen.routName);
          }
          if (state is SessionControllerError) {
            ErrorHandler(exception: state.exception)
                .showErrorSnackBar(context: context);
          }
        },
        builder: (context, state) {
          return Form(
            key: _keyForm,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(height: 20.h),
                    Image.asset(
                      Assets.assetsImagesCircleLogo,
                      width: 135,
                      height: 135,
                    ),
                    SizedBox(height: 40.h),
                    if (isSignUpWithEmail)
                      EditTextField(
                        controller: _controllerEmail,
                        label: S.current.email,
                        validator: (text) {
                          return TextInputValidator(validators: [
                            InputValidator.email,
                            InputValidator.requiredField
                          ]).validate(text);
                        },
                      ),
                    if (!isSignUpWithEmail)
                      EditTextField(
                          controller: _controllerPhone,
                          label: S.current.number,
                          isNumber: true,
                          withCountryCodePicker: true,
                          countryCodeController: _countryCodeController),
                    SizedBox(height: 15.0),
                    EditTextField(
                        controller: _controllerPassword,
                        label: S.current.password,
                        isPass: true),
                    SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              AppCheckBox(
                                value: _rememberMe,
                                onChange: () => setState(() {
                                  _rememberMe = !_rememberMe;
                                }),
                              ),
                              SizedBox(width: 5.w),
                              Text(
                                S.current.rememberMe,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      color: Theme.of(context).primaryColorDark,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        Flexible(
                          child: TextButton(
                            child: Text(
                              S.current.forgotPassword,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    color: Theme.of(context).primaryColorDark,
                                  ),
                            ),
                            onPressed: () {
                              Navigator.of(context)
                                  .pushNamed(ResetPasswordScreen.routName);
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.0),
                    CustomElevatedButton(
                      isLoading: state is SessionControllerLoading,
                      margin: EdgeInsets.only(bottom: 10),
                      backgroundColor: AppColors.secondary,
                      withBorderRadius: true,
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        if (!_keyForm.currentState!.validate()) {
                          return;
                        }
                        LoginBody loginBody = LoginBody(
                          codeNumber: _countryCodeController.text,
                          password: _controllerPassword.text,
                          email:
                              isSignUpWithEmail ? _controllerEmail.text : null,
                          phoneNumber:
                              isSignUpWithEmail ? null : _controllerPhone.text,
                          fcmToken: FcmService.firebaseToken,
                        );
                        if (_rememberMe) {
                          prefs.setString(Constants.savedSignInCredentials,
                              loginBody.toJson());
                        }
                        _sessionControllerCubit.sigIn(loginBody);
                      },
                      child: Text(S.current.signIn,
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge
                              ?.copyWith(
                                  fontSize: 15.sp,
                                  color: AppColors.whiteColor)),
                    ),
                    CustomElevatedButton(
                      withBorderRadius: true,
                      borderColor: AppColors.dividerColor,
                      onPressed: () {
                        setState(() {
                          isSignUpWithEmail = !isSignUpWithEmail;
                        });
                      },
                      child: Text(
                          isSignUpWithEmail
                              ? S.current.signWithNumber
                              : S.current.signWithEmail,
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge
                              ?.copyWith(fontSize: 15.sp)),
                    ),
                    CustomElevatedButton(
                      withBorderRadius: true,
                      borderColor: AppColors.dividerColor,
                      onPressed: () {
                        Navigator.popAndPushNamed(
                            context, SignUpScreen.routName);
                      },
                      child: Text(S.current.createAccount,
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge
                              ?.copyWith(fontSize: 15.sp)),
                    ),
                    SizedBox(height: 20.0),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
