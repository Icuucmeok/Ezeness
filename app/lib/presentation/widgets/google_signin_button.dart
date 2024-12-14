import 'package:ezeness/logic/cubit/session_controller/session_controller_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../generated/l10n.dart';
import '../../res/app_res.dart';
import '../services/fcm_service.dart';
import 'common/common.dart';

class GoogleSignInButton extends StatefulWidget {
  const GoogleSignInButton({Key? key}) : super(key: key);

  @override
  State<GoogleSignInButton> createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  @override
  Widget build(BuildContext context) {
    return CustomElevatedButton(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      withBorderRadius: true,
      borderColor: AppColors.dividerColor,
      onPressed: () async {
        try {
          GoogleSignInAccount? googleResponse = await _googleSignIn.signIn();
          
          if (googleResponse != null) {
            GoogleSignInAuthentication googleAuth = await googleResponse.authentication;
            context.read<SessionControllerCubit>().socialSigIn(
              token: googleAuth.accessToken ?? '',
              provider: "google",
              fcmToken: FcmService.firebaseToken ?? '',
            );
            _googleSignIn.signOut(); 
          }
        } catch (error) {
          _showErrorDialog(context, error.toString());
        }
      },
      child: Row(
        children: [
          SvgPicture.asset(Assets.googleIcon, width: 40, height: 40),
          Expanded(child: SizedBox()),
          Text(S.current.continueWithGoogle),
          Expanded(child: SizedBox()),
          const SizedBox(width: 30),
        ],
      ),
    );
  }

void _showErrorDialog(BuildContext context, String errorMessage) {
  if (context.mounted) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text("Something went wrong: $errorMessage"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }
}

}
