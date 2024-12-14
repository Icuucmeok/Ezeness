import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../generated/l10n.dart';
import '../../../../logic/cubit/session_controller/session_controller_cubit.dart';
import '../../../../res/app_res.dart';
import '../../../utils/text_input_validator.dart';
import '../../../widgets/common/common.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResetPasswordSendCode extends StatefulWidget {
  const ResetPasswordSendCode({Key? key}) : super(key: key);

  @override
  State<ResetPasswordSendCode> createState() => _SignUpSecondState();
}

class _SignUpSecondState extends State<ResetPasswordSendCode> {
  final _keyForm = GlobalKey<FormState>();
  bool isEmail = true;

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPhone = TextEditingController();
  final TextEditingController _countryCodeController =
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
                    if (isEmail)
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
                    if (!isEmail)
                      EditTextField(
                          controller: _controllerPhone,
                          label: S.current.number,
                          isNumber: true,
                          withCountryCodePicker: true,
                          countryCodeController: _countryCodeController),
                    SizedBox(height: 10.0),
                    CustomElevatedButton(
                      isLoading: state is SessionControllerLoading,
                      margin: EdgeInsets.only(bottom: 10),
                      backgroundColor: AppColors.primaryColor,
                      withBorderRadius: true,
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        _sessionControllerCubit.sendResetPasswordCode(
                            resetValue: isEmail
                                ? _controllerEmail.text
                                : _controllerPhone.text,
                            isEmail: isEmail,
                            codeNumber: _countryCodeController.text);
                      },
                      child: Text(S.current.confirm,
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge
                              ?.copyWith(fontSize: 15.sp, color: Colors.white)),
                    ),
                    CustomElevatedButton(
                      withBorderRadius: true,
                      borderColor: AppColors.dividerColor,
                      onPressed: () {
                        setState(() {
                          isEmail = !isEmail;
                        });
                      },
                      child: Text( isEmail ? S.current.number : S.current.email,
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
}
