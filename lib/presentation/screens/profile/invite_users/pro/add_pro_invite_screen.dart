import 'package:ezeness/data/utils/error_handler.dart';
import 'package:ezeness/generated/l10n.dart';
import 'package:ezeness/logic/cubit/pro_invitation/pro_invitations_cubit.dart';
import 'package:ezeness/presentation/utils/app_snackbar.dart';
import 'package:ezeness/presentation/utils/text_input_validator.dart';
import 'package:ezeness/presentation/widgets/common/common.dart';
import 'package:ezeness/res/app_res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddProInviteScreen extends StatefulWidget {
  static const String routName = 'add_pro_invite';

  const AddProInviteScreen({Key? key, required this.proInvitationsCubit})
      : super(key: key);

  final ProInvitationsCubit proInvitationsCubit;

  @override
  State<AddProInviteScreen> createState() => _AddProInviteScreenState();
}

class _AddProInviteScreenState extends State<AddProInviteScreen> {
  TextEditingController titleController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(S.current.addProInvite),
        elevation: 0,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        children: [
          Text(
            S.current.addProInviteGroup,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
          ),
          SizedBox(height: 10.h),
          BlocConsumer<ProInvitationsCubit, ProInvitationsState>(
              bloc: widget.proInvitationsCubit,
              listener: (context, state) {
                if (state is ProInvitationsFailure) {
                  ErrorHandler(exception: state.exception)
                      .showErrorSnackBar(context: context);
                }
                if (state is SendProInvitationsDone) {
                  AppSnackBar(
                          context: context, message: S.current.sentSuccessfully)
                      .showSuccessSnackBar();
                  widget.proInvitationsCubit.getProInvitation();
                  titleController.clear();
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
                          controller: titleController,
                          label: S.current.title,
                          validator: (text) {
                            return TextInputValidator(
                              minLength: 8,
                              maxLength: 8,
                              validators: [
                                InputValidator.requiredField,
                              ],
                            ).validate(text);
                          },
                        ),
                        SizedBox(height: 20.h),
                        CustomElevatedButton(
                          isLoading: state is ProInvitationsLoading,
                          margin: EdgeInsets.only(top: 30, bottom: 30),
                          backgroundColor: AppColors.primaryColor,
                          child: Text(S.current.add,
                              style: Theme.of(context)
                                  .textTheme
                                  .displayLarge
                                  ?.copyWith(
                                      fontSize: 15.sp, color: Colors.white)),
                          onPressed: () {
                            FocusScope.of(context).unfocus();

                            if (!_formKey.currentState!.validate()) {
                              return;
                            }
                            widget.proInvitationsCubit
                                .sendProInvite(title: titleController.text);
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
