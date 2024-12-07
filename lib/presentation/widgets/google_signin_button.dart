import 'package:ezeness/logic/cubit/session_controller/session_controller_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
  @override
  Widget build(BuildContext context) {
    return  CustomElevatedButton(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      withBorderRadius: true,
      borderColor: AppColors.dividerColor,
      onPressed: () async{
        GoogleSignIn _googleSignIn = GoogleSignIn(
          scopes: ['email'],
        );
       GoogleSignInAccount? googleResponse= await _googleSignIn.signIn();
       if(googleResponse!=null){
         GoogleSignInAuthentication googleAuth= await googleResponse.authentication;
         context.read<SessionControllerCubit>().socialSigIn(
             token: googleAuth.accessToken.toString(),
             provider: "google",
           fcmToken: FcmService.firebaseToken??'',
         );
         _googleSignIn.signOut();
       }
      },
      child: Row(
        children: [
          SvgPicture.asset(Assets.googleIcon,width: 40,height: 40),
          Expanded(child: SizedBox()),
          Text(S.current.continueWithGoogle),
          Expanded(child: SizedBox()),
          const SizedBox(width: 30),
        ],
      ),
    );
  }
}
