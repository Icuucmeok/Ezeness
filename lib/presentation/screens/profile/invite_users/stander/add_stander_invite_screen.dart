import 'package:ezeness/data/models/invite_user/invite_user.dart';
import 'package:ezeness/data/models/user/user.dart';
import 'package:ezeness/data/utils/error_handler.dart';
import 'package:ezeness/generated/l10n.dart';
import 'package:ezeness/logic/cubit/app_config/app_config_cubit.dart';
import 'package:ezeness/logic/cubit/invite_user/invite_user_cubit.dart';
import 'package:ezeness/presentation/utils/app_snackbar.dart';
import 'package:ezeness/presentation/utils/text_input_validator.dart';
import 'package:ezeness/presentation/widgets/common/common.dart';
import 'package:ezeness/res/app_res.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddStanderInviteScreen extends StatefulWidget {
  const AddStanderInviteScreen({Key? key, required this.inviteUserCubit})
      : super(key: key);
  static const String routName = 'add_stander_invite';

  final InviteUserCubit inviteUserCubit;

  @override
  State<AddStanderInviteScreen> createState() => _AddStanderInviteScreenState();
}

class _AddStanderInviteScreenState extends State<AddStanderInviteScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  final TextEditingController countryCodeController = TextEditingController();
  TextEditingController multipleInviteCountController = TextEditingController();

  String? selectedInviteWay = S.current.singleInvite;

  late User user;
  late bool isAdmin;

  @override
  void initState() {
    user = context.read<AppConfigCubit>().getUser();
    isAdmin = user.role == Constants.superAdminRoleKey ||
        user.role == Constants.adminRoleKey;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(S.current.standardInvite),
        elevation: 0,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        children: [
          Text(
            S.current.standardInvite,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 15.h),
          BlocConsumer<InviteUserCubit, InviteUserState>(
              bloc: widget.inviteUserCubit,
              listener: (context, state) {
                if (state is InviteUserFailure) {
                  ErrorHandler(exception: state.exception)
                      .showErrorSnackBar(context: context);
                }
                if (state is InviteUserDone) {
                  AppSnackBar(
                          context: context, message: S.current.sentSuccessfully)
                      .showSuccessSnackBar();
                  widget.inviteUserCubit.getInvitation(0);
                  fullNameController.clear();
                  emailController.clear();
                  phoneController.clear();
                  multipleInviteCountController.clear();
                  Navigator.of(context).pop();
                }
              },
              builder: (context, state) {
                return Form(
                  key: _formKey,
                  child: Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        EditTextField(
                            controller: fullNameController,
                            label: S.current.fullName),
                        SizedBox(height: 10.h),
                        EditTextField(
                          controller: emailController,
                          label: S.current.email,
                          validator: (text) {
                            return TextInputValidator(
                                    validators: [InputValidator.email])
                                .validate(text);
                          },
                        ),
                        SizedBox(height: 10.h),
                        //FIRST VERSION EDITS
                        EditTextField(
                          controller: phoneController,
                          label: S.current.number,
                          countryCodeController: countryCodeController,
                          withCountryCodePicker: true,
                          isEmpty: true,
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              S.current.singleInvite,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    color: Theme.of(context).primaryColorDark,
                                  ),
                            ),
                            AppCheckBox(
                              value:
                                  selectedInviteWay == S.current.singleInvite,
                              onChange: () => setState(() {
                                selectedInviteWay = S.current.singleInvite;
                              }),
                            ),
                          ],
                        ),
                        if (isAdmin)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                S.current.multipleInvite,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      color: Theme.of(context).primaryColorDark,
                                    ),
                              ),
                              AppCheckBox(
                                value: selectedInviteWay ==
                                    S.current.multipleInvite,
                                onChange: () => setState(() {
                                  selectedInviteWay = S.current.multipleInvite;
                                }),
                              ),
                            ],
                          ),
                        if (selectedInviteWay == S.current.multipleInvite)
                          EditTextField(
                              controller: multipleInviteCountController,
                              label: "",
                              isNumber: true,
                              suffixWidget: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(S.current.invite),
                              )),

                        CustomElevatedButton(
                          withBorderRadius: true,
                          isLoading: state is InviteUserLoading,
                          margin: EdgeInsets.only(top: 30, bottom: 30),
                          backgroundColor: AppColors.primaryColor,
                          child: Text(S.current.invite,
                              style: Theme.of(context)
                                  .textTheme
                                  .displayLarge
                                  ?.copyWith(
                                      fontSize: 15.sp, color: Colors.white)),
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            if (phoneController.text.isEmpty &&
                                emailController.text.isEmpty) {
                              AppSnackBar(
                                      context: context,
                                      message: S.current
                                          .youMustFillPhoneOrEmailToContinue)
                                  .showErrorSnackBar();
                              return;
                            }
                            if (!_formKey.currentState!.validate()) {
                              return;
                            }
                            widget.inviteUserCubit.sendInvite(InviteUser(
                              name: fullNameController.text,
                              type: 0,
                              codeNumber: phoneController.text.isEmpty
                                  ? null
                                  : countryCodeController.text,
                              phoneNumber: phoneController.text.isEmpty
                                  ? null
                                  : phoneController.text,
                              email: emailController.text.isEmpty
                                  ? null
                                  : emailController.text,
                              extraCount:
                                  multipleInviteCountController.text.isEmpty
                                      ? null
                                      : multipleInviteCountController.text,
                            ));
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }),
        ],
      ),
    );
  }
}
