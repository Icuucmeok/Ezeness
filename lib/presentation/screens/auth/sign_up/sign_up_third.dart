import 'package:dropdown_search/dropdown_search.dart';
import 'package:ezeness/data/models/auth/signup_body.dart';
import 'package:ezeness/data/models/country_model.dart';
import 'package:ezeness/data/models/pick_location_model.dart';
import 'package:ezeness/presentation/utils/app_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../data/models/auth/edit_profile_body.dart';
import '../../../../data/models/user/user.dart';
import '../../../../generated/l10n.dart';
import '../../../../logic/cubit/profile/profile_cubit.dart';
import '../../../../logic/cubit/session_controller/session_controller_cubit.dart';
import '../../../../res/app_res.dart';
import '../../../services/fcm_service.dart';
import '../../../utils/text_input_validator.dart';
import '../../../widgets/common/common.dart';
import '../../profile/about/about_screen.dart';

class SignUpThird extends StatefulWidget {
  static const String routName = 'sign_up_third';
  final User? initialUser;
  const SignUpThird({this.initialUser, Key? key}) : super(key: key);

  @override
  State<SignUpThird> createState() => _SignUpThirdState();
}

class _SignUpThirdState extends State<SignUpThird> {
  final _passwordKeyForm = GlobalKey<FormState>();
  final _nameKeyForm = GlobalKey<FormState>();
  final _nationalityKeyForm = GlobalKey<FormState>();
  final _userNameKeyForm = GlobalKey<FormState>();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController birthDateController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  CountryModel? userNationality;
  int? selectedGender;
  PickLocationModel? pickLocation;
  bool locationError = false;
  bool birthdayError = false;
  bool isAccept = false;
  List<String> suggestions = [];

  late SessionControllerCubit _sessionControllerCubit;
  late ProfileCubit _profileCubit;

  checkLocationError() {
    if (pickLocation == null) {
      locationError = true;
    } else {
      locationError = false;
    }
    setState(() {});
  }

  checkBirthdayError() {
    if (birthDateController.text.isEmpty) {
      birthdayError = true;
    } else {
      birthdayError = false;
    }
    setState(() {});
  }

  nextPage() {
    _pageController.nextPage(
        duration: const Duration(milliseconds: 500), curve: Curves.linear);
  }

  previousPage() {
    _pageController.previousPage(
        duration: const Duration(milliseconds: 500), curve: Curves.linear);
  }

  final PageController _pageController = PageController();
  @override
  void initState() {
    if (widget.initialUser != null) {
      fullNameController.text = widget.initialUser!.name.toString();
    }
    _sessionControllerCubit = context.read<SessionControllerCubit>();
    _profileCubit = context.read<ProfileCubit>();
    PickLocationModel? userLocation = _sessionControllerCubit.getUserLocation();
    if (userLocation != null) {
      pickLocation = userLocation;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<SessionControllerCubit, SessionControllerState>(
          listener: (context, state) {
            if (state is SessionControllerSignUpInfoValidateDone) {
              nextPage();
            }
            if (state is SessionControllerUserNameSuggestionLoaded) {
              suggestions = state.response;
            }
          },
          bloc: _sessionControllerCubit,
          builder: (context, state) {
            return PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _pageController,
              children: [
                //PASSWORD
                if (widget.initialUser == null)
                  Form(
                    key: _passwordKeyForm,
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: ListView(
                        physics: const BouncingScrollPhysics(),
                        children: [
                          Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    _sessionControllerCubit
                                        .signedUpPreviousPage();
                                  },
                                  icon: Icon(Icons.arrow_back_ios_new_rounded)),
                              Text(
                                S.current.signUp,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
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
                          Text(
                            S.current.createPassword,
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.sp,
                                    ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            S.current.createPasswordText,
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: Theme.of(context)
                                          .primaryColorDark
                                          .withOpacity(0.7),
                                      fontSize: 18.sp,
                                    ),
                          ),
                          SizedBox(height: 20.h),
                          EditTextField(
                              controller: passwordController,
                              label: S.current.password,
                              isPass: true),
                          SizedBox(height: 8.h),
                          EditTextField(
                              controller: confirmPasswordController,
                              label:
                                  S.current.confirm + " " + S.current.password,
                              isPass: true),
                          CustomElevatedButton(
                            withBorderRadius: true,
                            margin: EdgeInsets.only(top: 30, bottom: 30),
                            backgroundColor: AppColors.secondary,
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              if (!_passwordKeyForm.currentState!.validate()) {
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
                              _sessionControllerCubit.validateSignUpInfo(
                                  body: SignUpBody(
                                      password: passwordController.text,
                                      passwordConfirmation:
                                          confirmPasswordController.text));
                            },
                            child: Text(S.current.next,
                                style: Theme.of(context)
                                    .textTheme
                                    .displayLarge
                                    ?.copyWith(
                                        fontSize: 15.sp, color: Colors.white)),
                          ),
                        ],
                      ),
                    ),
                  ),

                //NAME
                Form(
                  key: _nameKeyForm,
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      children: [
                        Row(
                          children: [
                            IconButton(
                                onPressed: () {
                                  previousPage();
                                },
                                icon: Icon(Icons.arrow_back_ios_new_rounded)),
                            Text(
                              S.current.signUp,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
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
                        Text(
                          S.current.whatYourName,
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.sp,
                                  ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          S.current.nameText,
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: Theme.of(context)
                                        .primaryColorDark
                                        .withOpacity(0.7),
                                    fontSize: 18.sp,
                                  ),
                        ),
                        SizedBox(height: 20.h),
                        EditTextField(
                            controller: fullNameController,
                            validator: (text) {
                              return TextInputValidator(
                                  minLength: 5,
                                  validators: [
                                    InputValidator.minLength,
                                    InputValidator.requiredField
                                  ]).validate(text);
                            },
                            label: S.current.fullName),
                        SizedBox(height: 8.h),
                        CustomElevatedButton(
                          withBorderRadius: true,
                          margin: EdgeInsets.only(top: 30, bottom: 30),
                          backgroundColor: AppColors.secondary,
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            if (!_nameKeyForm.currentState!.validate()) {
                              return;
                            }
                            _sessionControllerCubit.getUserNameSuggestion(
                                fullNameController.text.substring(
                                    0, fullNameController.text.length ~/ 2));
                            nextPage();
                          },
                          child: Text(S.current.next,
                              style: Theme.of(context)
                                  .textTheme
                                  .displayLarge
                                  ?.copyWith(
                                      fontSize: 15.sp, color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                ),

                //BIRTHDAY
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                previousPage();
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
                                      fontSize: 18.sp,
                                    ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      Text(
                        S.current.whatYourBirthday,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.sp,
                            ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        S.current.birthdayText,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context)
                                  .primaryColorDark
                                  .withOpacity(0.7),
                              fontSize: 18.sp,
                            ),
                      ),
                      SizedBox(height: 20.h),
                      PickDate(
                        controller: birthDateController,
                        title: S.current.birthdate,
                        isError: birthdayError,
                        isBottomPicker: true,
                      ),
                      SizedBox(height: 8.h),
                      CustomElevatedButton(
                        withBorderRadius: true,
                        margin: EdgeInsets.only(top: 30, bottom: 16),
                        backgroundColor: AppColors.secondary,
                        onPressed: () {
                          checkBirthdayError();
                          if (birthdayError) {
                            return;
                          }
                          _sessionControllerCubit.validateSignUpInfo(
                              body: SignUpBody(
                                  birthDate: birthDateController.text));
                        },
                        child: Text(S.current.next,
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge
                                ?.copyWith(
                                    fontSize: 15.sp, color: Colors.white)),
                      ),
                      if (!AppData.isUserProfileBirthDateRequired)
                        CustomElevatedButton(
                          withBorderRadius: true,
                          margin: EdgeInsets.only(top: 0, bottom: 30),
                          borderColor: AppColors.outlineButton,
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            birthDateController.clear();
                            nextPage();
                          },
                          child: Text(S.current.notNow,
                              style: Theme.of(context)
                                  .textTheme
                                  .displayLarge
                                  ?.copyWith(fontSize: 15.sp)),
                        ),
                    ],
                  ),
                ),

                //nationality
                Form(
                  key: _nationalityKeyForm,
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      children: [
                        Row(
                          children: [
                            IconButton(
                                onPressed: () {
                                  previousPage();
                                },
                                icon: Icon(Icons.arrow_back_ios_new_rounded)),
                            Text(
                              S.current.signUp,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
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
                        Text(
                          S.current.whatYourNationality,
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.sp,
                                  ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          S.current.nationalityText,
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: Theme.of(context)
                                        .primaryColorDark
                                        .withOpacity(0.7),
                                    fontSize: 18.sp,
                                  ),
                        ),
                        SizedBox(height: 20.h),
                        _buildSearchNationality(context),
                        SizedBox(height: 8.h),
                        CustomElevatedButton(
                          withBorderRadius: true,
                          margin: EdgeInsets.only(top: 30, bottom: 16),
                          backgroundColor: AppColors.secondary,
                          onPressed: () {
                            if (!_nationalityKeyForm.currentState!.validate()) {
                              return;
                            }
                            _sessionControllerCubit.validateSignUpInfo(
                                body: SignUpBody(
                              userNationality: userNationality?.value,
                            ));
                          },
                          child: Text(S.current.next,
                              style: Theme.of(context)
                                  .textTheme
                                  .displayLarge
                                  ?.copyWith(
                                      fontSize: 15.sp, color: Colors.white)),
                        ),
                        if (!AppData.isUserProfileNationalityRequired)
                          CustomElevatedButton(
                            withBorderRadius: true,
                            margin: EdgeInsets.only(top: 0, bottom: 30),
                            borderColor: AppColors.outlineButton,
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              userNationality = null;
                              nextPage();
                            },
                            child: Text(S.current.notNow,
                                style: Theme.of(context)
                                    .textTheme
                                    .displayLarge
                                    ?.copyWith(fontSize: 15.sp)),
                          ),
                      ],
                    ),
                  ),
                ),

                //GENDER
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                previousPage();
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
                                      fontSize: 18.sp,
                                    ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      Text(
                        S.current.selectYourGender,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.sp,
                            ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        S.current.genderText,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context)
                                  .primaryColorDark
                                  .withOpacity(0.7),
                              fontSize: 18.sp,
                            ),
                      ),
                      SizedBox(height: 20.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                AppCheckBox(
                                  value: selectedGender == Constants.maleKey,
                                  onChange: () => setState(() {
                                    selectedGender = Constants.maleKey;
                                  }),
                                ),
                                SizedBox(width: 5.w),
                                Text(
                                  S.current.male,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                        color:
                                            Theme.of(context).primaryColorDark,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                AppCheckBox(
                                  value: selectedGender == Constants.femaleKey,
                                  onChange: () => setState(() {
                                    selectedGender = Constants.femaleKey;
                                  }),
                                ),
                                SizedBox(width: 5.w),
                                Text(
                                  S.current.female,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                        color:
                                            Theme.of(context).primaryColorDark,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      CustomElevatedButton(
                        isLoading: state is SessionControllerLoading,
                        withBorderRadius: true,
                        margin: EdgeInsets.only(top: 30, bottom: 30),
                        backgroundColor: AppColors.secondary,
                        onPressed: () {
                          nextPage();
                        },
                        child: Text(S.current.next,
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge
                                ?.copyWith(
                                    fontSize: 15.sp, color: Colors.white)),
                      ),
                      if (!AppData.isUserProfileGenderRequired)
                        CustomElevatedButton(
                          withBorderRadius: true,
                          margin: EdgeInsets.only(top: 0, bottom: 30),
                          borderColor: AppColors.outlineButton,
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            selectedGender = null;
                            nextPage();
                          },
                          child: Text(S.current.notNow,
                              style: Theme.of(context)
                                  .textTheme
                                  .displayLarge
                                  ?.copyWith(fontSize: 15.sp)),
                        ),
                    ],
                  ),
                ),

                //USERNAME
                Form(
                  key: _userNameKeyForm,
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      children: [
                        Row(
                          children: [
                            IconButton(
                                onPressed: () {
                                  previousPage();
                                },
                                icon: Icon(Icons.arrow_back_ios_new_rounded)),
                            Text(
                              S.current.signUp,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
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
                        Text(
                          S.current.createUsername,
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.sp,
                                  ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          S.current.userNmeText,
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: Theme.of(context)
                                        .primaryColorDark
                                        .withOpacity(0.7),
                                    fontSize: 18.sp,
                                  ),
                        ),
                        SizedBox(height: 20.h),
                        EditTextField(
                          controller: userNameController,
                          label: S.current.userName,
                          inputFormatters: [
                            FilteringTextInputFormatter.deny(RegExp(r'\s')),
                          ],
                          onChanged: () {
                            _sessionControllerCubit
                                .getUserNameSuggestion(userNameController.text);
                          },
                          validator: (text) {
                            return TextInputValidator(validators: [
                              InputValidator.requiredField,
                              InputValidator.userName,
                            ]).validate(text);
                          },
                        ),
                        SizedBox(height: 20.h),
                        if (state
                            is SessionControllerUserNameSuggestionLoading) ...{
                          const CenteredCircularProgressIndicator(),
                        } else ...{
                          Text(S.current.suggestion + " " + S.current.userName,
                              style: Theme.of(context)
                                  .textTheme
                                  .displayLarge
                                  ?.copyWith(
                                      color: AppColors.secondary,
                                      fontSize: 16)),
                          SizedBox(height: 10.h),
                          ...suggestions
                              .map(
                                (e) => InkWell(
                                    onTap: () {
                                      setState(() {
                                        userNameController.text = e;
                                      });
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.all(4.0),
                                      child: Text(e,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge
                                              ?.copyWith(
                                                  color: Colors.green,
                                                  fontSize: 16)),
                                    )),
                              )
                              .toList(),
                        },
                        CustomElevatedButton(
                          isLoading: state is SessionControllerLoading,
                          withBorderRadius: true,
                          margin: EdgeInsets.only(top: 30, bottom: 30),
                          backgroundColor: AppColors.secondary,
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            if (!_userNameKeyForm.currentState!.validate()) {
                              return;
                            }
                            _sessionControllerCubit.validateSignUpInfo(
                                body: SignUpBody(
                                    username: userNameController.text));
                          },
                          child: Text(S.current.save,
                              style: Theme.of(context)
                                  .textTheme
                                  .displayLarge
                                  ?.copyWith(
                                      fontSize: 15.sp, color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                ),

                //LOCATION
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                previousPage();
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
                                      fontSize: 18.sp,
                                    ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      PickLocation(
                          initialLocation: pickLocation == null
                              ? null
                              : pickLocation!.location,
                          isError: locationError,
                          onChange: (location) {
                            pickLocation = location;
                          }),
                      CustomElevatedButton(
                        isLoading: state is SessionControllerLoading,
                        withBorderRadius: true,
                        margin: EdgeInsets.only(top: 30, bottom: 30),
                        backgroundColor: AppColors.secondary,
                        onPressed: () {
                          checkLocationError();
                          if (locationError) {
                            return;
                          }
                          nextPage();
                        },
                        child: Text(S.current.next,
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge
                                ?.copyWith(
                                    fontSize: 15.sp, color: Colors.white)),
                      ),
                      if (!AppData.isUserProfileLocationRequired)
                        CustomElevatedButton(
                          withBorderRadius: true,
                          margin: EdgeInsets.only(top: 0, bottom: 30),
                          borderColor: AppColors.outlineButton,
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            pickLocation = null;
                            nextPage();
                          },
                          child: Text(S.current.notNow,
                              style: Theme.of(context)
                                  .textTheme
                                  .displayLarge
                                  ?.copyWith(fontSize: 15.sp)),
                        ),
                    ],
                  ),
                ),

                //TERMSConditions
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                previousPage();
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
                                      fontSize: 18.sp,
                                    ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      Text(
                        S.current.agreeTermsConditions,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.sp,
                            ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        S.current.termsConditionsText,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context)
                                  .primaryColorDark
                                  .withOpacity(0.7),
                              fontSize: 18.sp,
                            ),
                      ),
                      SizedBox(height: 20.h),
                      Text(
                        S.current.accept,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColorDark,
                              fontSize: 18.sp,
                            ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              Navigator.pushNamed(
                                  context, AboutScreen.routName);
                            },
                            child: Text(
                              S.current.termsAndConditions,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                    color: AppColors.secondary,
                                    letterSpacing: 0.005,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.sp,
                                  ),
                            ),
                          ),
                          AppCheckBox(
                            value: isAccept,
                            onChange: () => setState(() {
                              isAccept = !isAccept;
                            }),
                          ),
                        ],
                      ),
                      CustomElevatedButton(
                        isLoading: state is SessionControllerLoading,
                        withBorderRadius: true,
                        margin: EdgeInsets.only(top: 30, bottom: 30),
                        backgroundColor: AppColors.secondary,
                        onPressed: () {
                          if (!isAccept) {
                            AppSnackBar(
                                    message: S.current.accept +
                                        " " +
                                        S.current.termsAndConditions,
                                    context: context)
                                .showErrorSnackBar();
                            return;
                          }
                          if (widget.initialUser == null) {
                            _sessionControllerCubit.signUp(
                              SignUpBody(
                                password: passwordController.text,
                                passwordConfirmation:
                                    confirmPasswordController.text,
                                name: fullNameController.text,
                                birthDate: birthDateController.text,
                                lat: pickLocation == null
                                    ? null
                                    : pickLocation!.lat,
                                lng: pickLocation == null
                                    ? null
                                    : pickLocation!.lng,
                                address: pickLocation == null
                                    ? null
                                    : pickLocation!.location,
                                gender: selectedGender,
                                userNationality: userNationality?.value,
                                username: userNameController.text,
                                fcmToken: FcmService.firebaseToken,
                              ),
                            );
                          } else {
                            _profileCubit.editProfile(
                              body: EditProfileBody(
                                name: fullNameController.text,
                                birthDate: birthDateController.text,
                                lat: pickLocation?.lat,
                                lng: pickLocation?.lng,
                                gender: selectedGender,
                                username: userNameController.text,
                                address: pickLocation?.location,
                                userNationality: userNationality?.value,
                                inviteCode:
                                    _sessionControllerCubit.getInviteCode(),
                              ),
                            );
                          }
                        },
                        child: Text(S.current.accept + " & " + S.current.save,
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge
                                ?.copyWith(
                                    fontSize: 15.sp, color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
    );
  }

  DropdownSearch<CountryModel> _buildSearchNationality(BuildContext context) {
    return DropdownSearch<CountryModel>(
      itemAsString: (item) => item.title.toUpperCase() + " (${item.value})",
      items: AppData.countries,
      validator: (val) => val == null ? S.current.requiredField : null,
      onChanged: (value) {
        setState(() {
          userNationality = value;
        });
      },
      dropdownDecoratorProps: DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          labelText: S.current.nationality,
          hintText: S.current.nationality,
          border: OutlineInputBorder(
              borderSide:
                  const BorderSide(color: AppColors.textFieldBorderLight),
              borderRadius: BorderRadius.circular(15)),
          disabledBorder: OutlineInputBorder(
              borderSide:
                  const BorderSide(color: AppColors.textFieldBorderLight),
              borderRadius: BorderRadius.circular(15)),
          enabledBorder: OutlineInputBorder(
              borderSide:
                  const BorderSide(color: AppColors.textFieldBorderLight),
              borderRadius: BorderRadius.circular(15)),
          errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.red),
              borderRadius: BorderRadius.circular(15)),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColors.textFieldBorderLight),
            borderRadius: BorderRadius.circular(15),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 16),
          labelStyle: TextStyle(),
        ),
      ),
      popupProps: PopupProps.menu(
          showSelectedItems: true,
          showSearchBox: true,
          searchFieldProps: TextFieldProps(
            maxLines: 1,
            decoration: InputDecoration(
              hintText: S.current.search,
              fillColor: Colors.transparent,
              filled: true,
              isDense: true,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 10, vertical: 14),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              errorStyle: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(color: Colors.red),
              border: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: AppColors.textFieldBorderLight),
                  borderRadius: BorderRadius.circular(7)),
              disabledBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: AppColors.textFieldBorderLight),
                  borderRadius: BorderRadius.circular(7)),
              enabledBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: AppColors.textFieldBorderLight),
                  borderRadius: BorderRadius.circular(7)),
              errorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.circular(7)),
              focusedBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(color: AppColors.textFieldBorderLight),
                borderRadius: BorderRadius.circular(7),
              ),
            ),
          )),
      selectedItem: userNationality,
      enabled: true,
      compareFn: (CountryModel a, CountryModel b) => a.value == b.value,
    );
  }
}
