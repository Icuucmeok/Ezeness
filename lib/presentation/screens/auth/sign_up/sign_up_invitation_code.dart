import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data/models/user/user.dart';
import '../../../../generated/l10n.dart';
import '../../../../logic/cubit/session_controller/session_controller_cubit.dart';
import '../../../../res/app_res.dart';
import '../../../widgets/common/common.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignUpInvitationCode extends StatefulWidget {
  static const String routName = 'sign_up_third';
  final User? initialUser;
  const SignUpInvitationCode({this.initialUser, Key? key}) : super(key: key);

  @override
  State<SignUpInvitationCode> createState() => _SignUpInvitationCodeState();
}

class _SignUpInvitationCodeState extends State<SignUpInvitationCode> {
  final _keyForm = GlobalKey<FormState>();
  TextEditingController controllerInvitationCode = TextEditingController();
  late SessionControllerCubit _sessionControllerCubit;
  @override
  void initState() {
    _sessionControllerCubit = context.read<SessionControllerCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<SessionControllerCubit, SessionControllerState>(
          bloc: _sessionControllerCubit,
          builder: (context, state) {
            return Form(
              key: _keyForm,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 25.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (widget.initialUser == null)
                          IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(Icons.arrow_back_ios_new_rounded)),
                        Text(
                          S.current.signUp,
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context)
                                        .primaryColorDark
                                        .withOpacity(0.7),
                                    fontSize: 16,
                                  ),
                        ),
                        Spacer(),
                        Container(
                          width: 90,
                          height: 35,
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          child: Image.asset(
                            Theme.of(context).brightness == Brightness.dark
                                ? Assets.assetsImagesEzenessLogoDark
                                : Assets.assetsImagesEzenessLogoLight,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      S.current.doYouHaveInvitationCode,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp,
                          ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      S.current.enterYourInvitationCode,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context)
                                .primaryColorDark
                                .withOpacity(0.7),
                            fontSize: 14.sp,
                          ),
                    ),
                    SizedBox(height: 20.h),
                    EditTextField(
                      controller: controllerInvitationCode,
                      label: S.current.invitationCode,
                      hintText: S.current.invitationCode,
                    ),
                    SizedBox(height: 20.h),
                    CustomElevatedButton(
                      isLoading: state is SessionControllerLoading,
                      withBorderRadius: true,
                      backgroundColor: AppColors.secondary,
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        if (!_keyForm.currentState!.validate()) {
                          return;
                        }
                        _sessionControllerCubit
                            .checkInvitationCode(controllerInvitationCode.text);
                      },
                      child: Text(S.current.verify,
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge
                              ?.copyWith(fontSize: 15, color: Colors.white)),
                    ),
                    CustomElevatedButton(
                      withBorderRadius: true,
                      borderColor: AppColors.outlineButton,
                      onPressed: () {
                        _sessionControllerCubit.signedUpNextPage();
                      },
                      child: Text(S.current.doNotHaveInvitation,
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge
                              ?.copyWith(fontSize: 15)),
                    ),
                    //  CustomOutlineButton(
                    //    wSize: MediaQuery.of(context).size.width,
                    //    bgColor: Theme.of(context).brightness == Brightness.dark
                    //        ? Colors.grey.withOpacity(0.0)
                    //        : Colors.grey.withOpacity(0.0),
                    //    borderColor:
                    //    Theme.of(context).brightness == Brightness.dark
                    //        ? Colors.orangeAccent.withOpacity(0.5)
                    //        : Colors.orangeAccent.withOpacity(0.5),
                    //    textColor: Theme.of(context).brightness == Brightness.dark
                    //        ? Colors.white.withOpacity(0.9)
                    //        : Colors.black.withOpacity(0.9),
                    //    onPressed: () {
                    //      AppDialog.showSendInvitationDialog(context: context);
                    //    },
                    //    labelText: S.current.doNotHaveInvitation,
                    //  ),
                    // SizedBox(height: 10.h),
                    //  CustomElevatedButton(
                    //    backgroundColor:
                    //    Theme.of(context).brightness == Brightness.dark
                    //        ? Colors.blueGrey.withOpacity(0.0)
                    //        : Colors.blueGrey.withOpacity(0.0),
                    //    borderColor:
                    //    Theme.of(context).brightness == Brightness.dark
                    //        ? Colors.blue.withOpacity(0.9)
                    //        : Colors.blue.withOpacity(0.9),
                    //    child:  RichText(
                    //      textAlign: TextAlign.center,
                    //      text: TextSpan(
                    //        style: DefaultTextStyle.of(context).style,
                    //        children: [
                    //          TextSpan(
                    //              text: S.current.haveAccount + " ",
                    //              style: Theme.of(context).textTheme.bodyLarge!),
                    //          TextSpan(
                    //            text: S.current.signIn,
                    //            style: Theme.of(context).textTheme.bodyLarge!.copyWith(color:  AppColors.primaryColor),
                    //          ),
                    //        ],
                    //      ),
                    //    ),
                    //    onPressed: () {
                    //      Navigator.pushReplacementNamed(context, SignInScreen.routName);
                    //    },
                    //  ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
