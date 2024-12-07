import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../generated/l10n.dart';
import '../../../../logic/cubit/session_controller/session_controller_cubit.dart';
import '../../../../res/app_res.dart';
import '../../../utils/app_snackbar.dart';
import '../../../widgets/common/common.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResetPasswordCheckCode extends StatefulWidget {
  const ResetPasswordCheckCode({Key? key}) : super(key: key);

  @override
  State<ResetPasswordCheckCode> createState() => _SignUpSecondState();
}

class _SignUpSecondState extends State<ResetPasswordCheckCode> {
  final _keyForm = GlobalKey<FormState>();
  TextEditingController verificationCodeController = TextEditingController();
  int _start = 30;
  late SessionControllerCubit _sessionControllerCubit;
  late Timer timer;
  @override
  void initState() {
    startTimer();
    _sessionControllerCubit = context.read<SessionControllerCubit>();
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<SessionControllerCubit, SessionControllerState>(
          listener: (context, state) {
            if (state is SessionControllerResetPasswordCodeReSent) {
              AppSnackBar(message: S.current.sentSuccessfully, context: context)
                  .showSuccessSnackBar();
              startTimer();
            }
          },
          bloc: _sessionControllerCubit,
          builder: (context, state) {
            return Form(
              key: _keyForm,
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          S.current.verify,
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context)
                                        .primaryColorDark
                                        .withOpacity(0.7),
                                    fontSize: 18.sp,
                                  ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    EditTextField(
                        controller: verificationCodeController,
                        label: S.current.verificationCode),
                    CustomElevatedButton(
                      isLoading: state is SessionControllerLoading,
                      margin: EdgeInsets.only(top: 10, bottom: 10),
                      backgroundColor: AppColors.primaryColor,
                      withBorderRadius: true,
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        if (!_keyForm.currentState!.validate()) {
                          return;
                        }
                        _sessionControllerCubit.checkResetPasswordCode(
                            code: verificationCodeController.text);
                      },
                      child: Text(S.current.verify,
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge
                              ?.copyWith(fontSize: 15, color: Colors.white)),
                    ),
                    CustomElevatedButton(
                      withBorderRadius: true,
                      borderColor: AppColors.dividerColor,
                      onPressed: _start != 0
                          ? null
                          : () {
                              _sessionControllerCubit.resendResetPasswordCode();
                            },
                      child: Text( S.current.resendCode +
                          (_start == 0 ? "" : " $_start s"),
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge
                              ?.copyWith(fontSize: 15.sp)),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  void startTimer() {
    _start = 30;
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(
      oneSec,
      (Timer t) {
        if (_start == 0) {
          setState(() {
            t.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }
}
