import 'package:ezeness/generated/l10n.dart';
import 'package:ezeness/presentation/widgets/common/common.dart';
import 'package:ezeness/res/app_res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditBioScreen extends StatefulWidget {
  const EditBioScreen({required this.controller});
  static const String routName = 'edit_bio';

  final TextEditingController controller;

  @override
  State<EditBioScreen> createState() => _EditBioScreenState();
}

class _EditBioScreenState extends State<EditBioScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.editBio),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        children: [
          EditTextField(
            controller: widget.controller,
            label: S.current.bio,
            hintText: S.current.addSomethingAboutYourself,
            isEmpty: true,
            // isReadOnly: true,
            maxLength: 5000,
            minLine: 5,
            maxLine: 20,
          ),
          SizedBox(height: 50),
          CustomElevatedButton(
            withBorderRadius: true,
            margin: EdgeInsets.only(top: 30, bottom: 30),
            backgroundColor: AppColors.primaryColor,
            child: Text(
              S.current.done,
              style: Theme.of(context)
                  .textTheme
                  .displayLarge
                  ?.copyWith(fontSize: 15.sp, color: AppColors.whiteColor),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}
