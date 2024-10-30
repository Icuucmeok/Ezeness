import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../generated/l10n.dart';
import '../../res/app_res.dart';
import 'common/common.dart';

class AppleSignInButton extends StatefulWidget {
  const AppleSignInButton({Key? key}) : super(key: key);

  @override
  State<AppleSignInButton> createState() => _AppleSignInButtonState();
}

class _AppleSignInButtonState extends State<AppleSignInButton> {
  @override
  Widget build(BuildContext context) {
    return  CustomElevatedButton(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      withBorderRadius: true,
      borderColor: AppColors.dividerColor,
      onPressed: () async{
        final credential = await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
        );

        print(credential.identityToken);
      },
      child: Row(
        children: [
          const SizedBox(width: 4),
          SvgPicture.asset(Assets.appleIcon,width: 40,height: 40),
          Expanded(child: SizedBox()),
          Text(S.current.continueWithApple),
          Expanded(child: SizedBox()),
          const SizedBox(width: 30),
        ],
      ),
    );
  }
}
