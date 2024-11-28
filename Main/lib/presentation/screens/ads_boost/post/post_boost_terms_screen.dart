// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:ezeness/data/models/boost/plans/boost_plans_model.dart';
import 'package:ezeness/data/models/post/post.dart';
import 'package:ezeness/generated/l10n.dart';
import 'package:ezeness/presentation/screens/ads_boost/post/post_boost_payment_screen.dart';
import 'package:ezeness/presentation/widgets/common/common.dart';
import 'package:ezeness/res/app_res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PostBoostTermsScreen extends StatelessWidget {
  static const String routName = 'post_terms';

  const PostBoostTermsScreen({
    Key? key,
    required this.post,
    required this.plan,
  }) : super(key: key);

  final Post post;
  final BoostPlansModel plan;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(S.current.terms),
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              S.current.agreeTermsConditions,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            SizedBox(height: 20),
            Text(
              S.current.peopleUseServices,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: AppColors.greyDark, fontSize: 18.sp),
            ),
            SizedBox(height: 40),
            // Next button
            CustomElevatedButton(
              margin: EdgeInsets.only(bottom: 10, left: 20, right: 20, top: 10),
              backgroundColor: AppColors.primaryColor,
              withBorderRadius: true,
              onPressed: () {
                Navigator.of(context).pushNamed(
                  PostBoostPaymentScreen.routName,
                  arguments: {
                    "post": post,
                    "plan": plan,
                  },
                );
              },
              child: Text(
                S.current.iAgree,
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontSize: 15.sp,
                      color: AppColors.whiteColor,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
