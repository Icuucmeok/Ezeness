import 'package:ezeness/generated/l10n.dart';
import 'package:ezeness/presentation/widgets/common/common.dart';
import 'package:ezeness/res/app_res.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../logic/cubit/upgrade_username/upgrade_username_cubit.dart';
import '../../../utils/text_input_validator.dart';

class EditUsernameScreen extends StatefulWidget {
  const EditUsernameScreen({required this.controller});
  static const String routName = 'edit_username_screen';

  final TextEditingController controller;

  @override
  State<EditUsernameScreen> createState() => _EditUsernameScreenState();
}

class _EditUsernameScreenState extends State<EditUsernameScreen> {
  final _keyForm = GlobalKey<FormState>();
  late UpgradeUserNameCubit _upgradeUserNameCubit;

  @override
  void initState() {
    _upgradeUserNameCubit = context.read<UpgradeUserNameCubit>();
    _upgradeUserNameCubit.getMySuggestion();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: _keyForm,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          children: [
            EditTextField(
              controller: widget.controller,
              label: S.current.userName,
              inputFormatters: [
                FilteringTextInputFormatter.deny(RegExp(r'\s')),
              ],
              validator: (text) {
                return TextInputValidator(validators: [
                  InputValidator.requiredField,
                  InputValidator.userName,
                ]).validate(text);
              },
            ),
            SizedBox(height: 30),
            CustomElevatedButton(
              margin: EdgeInsets.only(top: 30, bottom: 30),
              backgroundColor: AppColors.primaryColor,
              child: Text(
                S.current.done,
                style: Theme.of(context)
                    .textTheme
                    .displayLarge
                    ?.copyWith(fontSize: 15.sp, color: AppColors.whiteColor),
              ),
              onPressed: () {
                if (!_keyForm.currentState!.validate()) {
                  return;
                }
                Navigator.of(context).pop();
              },
            ),
            BlocBuilder<UpgradeUserNameCubit, UpgradeUserNameState>(
                bloc: _upgradeUserNameCubit,
                builder: (context, state) {
                  if (state is GetMySuggestionLoading) {
                    return CenteredCircularProgressIndicator();
                  }
                  if (state is MySuggestionLoaded) {
                    List<String> suggestions = state.response;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: suggestions
                          .map(
                            (e) => InkWell(
                                onTap: () {
                                  setState(() {
                                    widget.controller.text = e;
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
                    );
                  }
                  return SizedBox();
                }),
          ],
        ),
      ),
    );
  }
}
