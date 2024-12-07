import 'package:ezeness/presentation/screens/auth/sign_up/sign_up_invitation_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ezeness/logic/cubit/session_controller/session_controller_cubit.dart';
import 'package:ezeness/presentation/screens/auth/sign_up/sign_up_first.dart';
import 'package:ezeness/presentation/screens/auth/sign_up/sign_up_second.dart';
import 'package:ezeness/presentation/screens/auth/sign_up/sign_up_third.dart';
import 'package:ezeness/presentation/utils/app_snackbar.dart';

import '../../../../data/models/user/user.dart';
import '../../../../data/utils/error_handler.dart';
import '../../../../generated/l10n.dart';
import '../../../../logic/cubit/profile/profile_cubit.dart';
import '../../home/home_screen.dart';

class SignUpScreen extends StatefulWidget {
  static const String routName = 'sign_up_screen';
  final User? initialUser;
  const SignUpScreen({this.initialUser, Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final PageController _pageController = PageController();
  late SessionControllerCubit _sessionControllerCubit;
  late ProfileCubit _profileCubit;

  @override
  void initState() {
    _sessionControllerCubit = context.read<SessionControllerCubit>();
    _profileCubit = context.read<ProfileCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<ProfileCubit, ProfileState>(
          bloc: _profileCubit,
          listener: (context, state) {
            if (state is EditProfileDone) {
              Navigator.of(context).pushReplacementNamed(HomeScreen.routName);
            }
            if (state is EditProfileFailure) {
              ErrorHandler(exception: state.exception)
                  .showErrorSnackBar(context: context);
            }
          },
          builder: (context, state) {
            return BlocConsumer<SessionControllerCubit, SessionControllerState>(
              bloc: _sessionControllerCubit,
              listener: (context, state) {
                if (state is SessionControllerInvitationCodeChecked) {
                  _pageController.animateToPage(1,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.linear);
                }
                if (state is SessionControllerVerificationSent) {
                  _pageController.animateToPage(2,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.linear);
                  AppSnackBar(
                          message: S.current.sentSuccessfully, context: context)
                      .showSuccessSnackBar();
                }
                if (state is SessionControllerCodeVerified) {
                  _pageController.animateToPage(3,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.linear);
                }
                if (state is SessionControllerSignedUp) {
                  Navigator.of(context)
                      .pushReplacementNamed(HomeScreen.routName);
                }
                if (state is SessionControllerError) {
                  ErrorHandler(exception: state.exception)
                      .showErrorSnackBar(context: context);
                }
                if (state is SessionControllerSignedUpNextPage) {
                  _pageController.nextPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.linear);
                }
                if (state is SessionControllerSignedUpPreviousPage) {
                  _pageController.previousPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.linear);
                }
              },
              builder: (context, state) {
                return PageView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: _pageController,
                  children: [
                    SignUpInvitationCode(initialUser: widget.initialUser),
                    if (widget.initialUser == null) ...{
                      SignUpFirst(),
                      SignUpSecond(),
                    },
                    SignUpThird(initialUser: widget.initialUser),
                  ],
                );
              },
            );
          }),
    );
  }
}
