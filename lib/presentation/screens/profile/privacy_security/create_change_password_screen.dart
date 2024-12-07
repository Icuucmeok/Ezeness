import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../data/models/user/user.dart';
import '../../../../data/utils/error_handler.dart';
import '../../../../generated/l10n.dart';
import '../../../../logic/cubit/app_config/app_config_cubit.dart';
import '../../../../logic/cubit/profile/profile_cubit.dart';
import '../../../../logic/cubit/session_controller/session_controller_cubit.dart';
import '../../../../res/app_res.dart';
import '../../../utils/app_snackbar.dart';
import '../../../widgets/common/common.dart';

class CreateChangePasswordScreen extends StatefulWidget {
  static const String routName = 'create_change_password_screen';
  const CreateChangePasswordScreen();

  @override
  State<CreateChangePasswordScreen> createState() =>
      _CreateChangePasswordScreenState();
}

class _CreateChangePasswordScreenState
    extends State<CreateChangePasswordScreen> {
  final _keyForm = GlobalKey<FormState>();
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  late SessionControllerCubit _sessionControllerCubit;

  @override
  void initState() {
    _sessionControllerCubit = context.read<SessionControllerCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    User user = context.read<AppConfigCubit>().getUser();
    return Scaffold(
      appBar: AppBar(title: Text(S.current.password)),
      body: BlocConsumer<SessionControllerCubit, SessionControllerState>(
          bloc: _sessionControllerCubit,
          listener: (context, state) {
            if (state is SessionControllerCreateChangePasswordDone) {
              context
                  .read<ProfileCubit>()
                  .getMyProfile(context.read<AppConfigCubit>());
              AppSnackBar(context: context, message: S.current.editSuccessfully)
                  .showSuccessSnackBar();
              Navigator.of(context).pop();
            }
            if (state is SessionControllerError) {
              ErrorHandler(exception: state.exception)
                  .showErrorSnackBar(context: context);
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _keyForm,
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  children: [
                    Text(
                      S.current.createPassword,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.sp,
                          ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      S.current.createPasswordText,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context)
                                .primaryColorDark
                                .withOpacity(0.7),
                            fontSize: 18.sp,
                          ),
                    ),
                    SizedBox(height: 20.h),
                    if (user.isSetPassword) ...{
                      EditTextField(
                          controller: oldPasswordController,
                          label: S.current.oldPassword,
                          isPass: true),
                      SizedBox(height: 8.h),
                    },
                    EditTextField(
                        controller: passwordController,
                        label: S.current.password,
                        isPass: true),
                    SizedBox(height: 8.h),
                    EditTextField(
                        controller: confirmPasswordController,
                        label: S.current.confirm + " " + S.current.password,
                        isPass: true),
                    CustomElevatedButton(
                      isLoading: state is SessionControllerLoading,
                      withBorderRadius: true,
                      margin: EdgeInsets.only(top: 30, bottom: 30),
                      backgroundColor: AppColors.secondary,
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        if (!_keyForm.currentState!.validate()) {
                          return;
                        }
                        if (passwordController.text.trim() !=
                            confirmPasswordController.text.trim()) {
                          AppSnackBar(
                                  message: S.current.passwordNotMatch,
                                  context: context)
                              .showErrorSnackBar();
                          return;
                        }

                        _sessionControllerCubit.createChangePassword(
                          password: passwordController.text,
                          passwordConfirmation: confirmPasswordController.text,
                          oldPassword: user.isSetPassword
                              ? oldPasswordController.text
                              : null,
                        );
                      },
                      child: Text(S.current.save,
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge
                              ?.copyWith(fontSize: 15.sp, color: Colors.white)),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
