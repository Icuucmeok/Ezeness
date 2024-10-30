import 'package:ezeness/presentation/screens/auth/reset_password/reset_password.dart';
import 'package:ezeness/presentation/screens/auth/reset_password/reset_password_check_code.dart';
import 'package:ezeness/presentation/screens/auth/reset_password/reset_password_send_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ezeness/logic/cubit/session_controller/session_controller_cubit.dart';
import '../../../../data/utils/error_handler.dart';
import '../../../../generated/l10n.dart';
import '../../../utils/app_snackbar.dart';


class ResetPasswordScreen extends StatefulWidget {
  static const String routName = 'reset_password_screen';

  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {

  late SessionControllerCubit _sessionControllerCubit;
  final PageController _pageController = PageController();
  @override
  void initState() {
    _sessionControllerCubit = context.read<SessionControllerCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocConsumer<SessionControllerCubit, SessionControllerState>(
        bloc: _sessionControllerCubit,
        listener: (context, state) {
          if(state is SessionControllerResetPasswordCodeSent){
            _pageController.animateToPage(1, duration: const Duration(milliseconds: 500), curve: Curves.linear);
            AppSnackBar(message: S.current.sentSuccessfully,context: context).showSuccessSnackBar();
          }
          if(state is SessionControllerResetPasswordCodeChecked){
            _pageController.animateToPage(2, duration: const Duration(milliseconds: 500), curve: Curves.linear);
          }
          if(state is SessionControllerResetPasswordDone){
            AppSnackBar(message: S.current.editSuccessfully,context: context).showSuccessSnackBar();
            Navigator.of(context).pop();
          }
          if (state is SessionControllerError) {
            ErrorHandler(exception: state.exception)
                .showErrorSnackBar(context: context);
          }
        },
        builder: (context, state) {
          return PageView(
            physics: const NeverScrollableScrollPhysics(),
            controller: _pageController,
            children: [
              ResetPasswordSendCode(),
              ResetPasswordCheckCode(),
              ResetPassword(),
            ],
          );
        },
      ),
    );
  }
}
