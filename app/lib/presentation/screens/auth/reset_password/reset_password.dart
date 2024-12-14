import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../generated/l10n.dart';
import '../../../../logic/cubit/session_controller/session_controller_cubit.dart';
import '../../../../res/app_res.dart';
import '../../../utils/app_snackbar.dart';
import '../../../widgets/common/common.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _SignUpSecondState();
}

class _SignUpSecondState extends State<ResetPassword> {
  final _keyForm = GlobalKey<FormState>();

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  late SessionControllerCubit _sessionControllerCubit;
  @override
  void initState() {
    _sessionControllerCubit = context.read<SessionControllerCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<SessionControllerCubit, SessionControllerState>(
          listener: (context, state) {},
          bloc: _sessionControllerCubit,
          builder: (context, state) {
            return Form(
              key: _keyForm,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: ListView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          S.current.resetPassword,
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
                        controller: passwordController,
                        label: S.current.password),
                    SizedBox(height: 8.h),
                    EditTextField(
                        controller: confirmPasswordController,
                        label: S.current.confirm + " " + S.current.password),
                    SizedBox(height: 10.0),
                    CustomElevatedButton(
                      isLoading: state is SessionControllerLoading,
                      margin: EdgeInsets.only(bottom: 10),
                      backgroundColor: AppColors.primaryColor,
                      withBorderRadius: true,
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        if (passwordController.text.trim() !=
                            confirmPasswordController.text.trim()) {
                          AppSnackBar(
                                  message: S.current.passwordNotMatch,
                                  context: context)
                              .showErrorSnackBar();
                          return;
                        }
                        if (!_keyForm.currentState!.validate()) {
                          return;
                        }
                        _sessionControllerCubit.resetPassword(
                            password: passwordController.text,
                            passwordConfirmation:
                                confirmPasswordController.text);
                      },
                      child: Text(S.current.confirm,
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
