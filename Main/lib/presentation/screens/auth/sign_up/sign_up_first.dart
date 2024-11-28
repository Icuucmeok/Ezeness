import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ezeness/presentation/screens/auth/sign_in_screen.dart';
import 'package:ezeness/presentation/widgets/common/common.dart';
import 'package:ezeness/res/app_res.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../generated/l10n.dart';
import '../../../../logic/cubit/session_controller/session_controller_cubit.dart';
import '../../../utils/text_input_validator.dart';

class SignUpFirst extends StatefulWidget {
  static const String routName = 'sign_up_first';
  const SignUpFirst({Key? key}) : super(key: key);

  @override
  State<SignUpFirst> createState() => _SignUpFirstState();
}

class _SignUpFirstState extends State<SignUpFirst> {
  bool isSignUpWithEmail = true;
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPhone = TextEditingController();
  final TextEditingController _countryCodeController =
      TextEditingController();
  final _keyForm = GlobalKey<FormState>();
  late SessionControllerCubit _sessionControllerCubit;
  @override
  void initState() {
    _sessionControllerCubit = context.read<SessionControllerCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionControllerCubit, SessionControllerState>(
        bloc: _sessionControllerCubit,
        builder: (context, state) {
          return Form(
            key: _keyForm,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            _sessionControllerCubit.signedUpPreviousPage();
                          },
                          icon: Icon(Icons.arrow_back_ios_new_rounded)),
                      Text(
                        S.current.signUp,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
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
                  if (isSignUpWithEmail) ...{
                    Text(
                      S.current.whatYourEmail,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.sp,
                          ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      S.current.emailText,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context)
                                .primaryColorDark
                                .withOpacity(0.7),
                            fontSize: 18.sp,
                          ),
                    ),
                    SizedBox(height: 20.h),
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
                  },

                  if (!isSignUpWithEmail)...{
                    Text(
                      S.current.whatYourMobile,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.sp,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      S.current.mobileText,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context)
                            .primaryColorDark
                            .withOpacity(0.7),
                        fontSize: 18.sp,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    EditTextField(controller: _controllerPhone,
                        label: S.current.number,
                        isNumber: true,
                        withCountryCodePicker: true,
                        countryCodeController: _countryCodeController),
                  },
                  SizedBox(height: 20.h),
                  CustomElevatedButton(
                    isLoading: state is SessionControllerLoading,
                    withBorderRadius: true,
                    backgroundColor: AppColors.secondary,
                    onPressed: () async {
                      FocusScope.of(context).unfocus();
                      if (!_keyForm.currentState!.validate()) {
                        return;
                      }

                      _sessionControllerCubit.sendVerificationCode(
                          value: isSignUpWithEmail
                              ? _controllerEmail.text
                              : _controllerPhone.text,
                          isSignUpWithEmail: isSignUpWithEmail,
                          codeNumber: _countryCodeController.text);
                    },
                    child: Text(S.current.signUp,
                        style: TextStyle( color: Colors.white)),
                  ),
                  SizedBox(height: 4.h),
                  CustomElevatedButton(
                    withBorderRadius: true,
                    borderColor: AppColors.dividerColor,
                    onPressed: () {
                      setState(() {
                        isSignUpWithEmail = !isSignUpWithEmail;
                      });
                    },
                    child: Text(isSignUpWithEmail? S.current.signWithNumber: S.current.signWithEmail,
                        style: Theme.of(context)
                            .textTheme
                            .displayLarge
                            ?.copyWith(fontSize: 15.sp)),
                  ),
                  Expanded(child: SizedBox()),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: TextButton(
                      child: Text(S.current.alreadyHaveAccount,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(fontSize: 16),
                          textAlign: TextAlign.center),
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                            context, SignInScreen.routName);
                      },
                    ),
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          );
        });
  }
}
