import 'package:ezeness/data/utils/error_handler.dart';
import 'package:ezeness/generated/l10n.dart';
import 'package:ezeness/logic/cubit/invite_user/invite_user_cubit.dart';
import 'package:ezeness/presentation/screens/profile/invite_users/stander/add_stander_invite_screen.dart';
import 'package:ezeness/presentation/screens/profile/invite_users/widgets/invite_widget.dart';
import 'package:ezeness/presentation/utils/app_dialog.dart';
import 'package:ezeness/presentation/utils/app_snackbar.dart';
import 'package:ezeness/presentation/utils/helpers.dart';
import 'package:ezeness/presentation/widgets/common/common.dart';
import 'package:ezeness/presentation/widgets/pull_to_refresh.dart';
import 'package:ezeness/res/app_res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StanderInvitesListScreen extends StatefulWidget {
  static const String routName = 'stander_invites_screen';

  const StanderInvitesListScreen({Key? key}) : super(key: key);

  @override
  State<StanderInvitesListScreen> createState() =>
      _StanderInvitesListScreenState();
}

class _StanderInvitesListScreenState extends State<StanderInvitesListScreen> {
  late InviteUserCubit _inviteUserCubit;

  @override
  void initState() {
    _inviteUserCubit = context.read<InviteUserCubit>();
    _inviteUserCubit.getInvitation(0);
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
      body: Column(
        children: [
          // Headers
          _buildHeaders(context),

          Expanded(
            child: BlocConsumer<InviteUserCubit, InviteUserState>(
                bloc: _inviteUserCubit,
                listener: (context, state) {
                  if (state is DeleteInviteDone) {
                    AppSnackBar(
                            message: S.current.deletedSuccessfully,
                            context: context)
                        .showSuccessSnackBar();
                    _inviteUserCubit.getInvitation(0);
                  }
                },
                builder: (context, state) {
                  if (state is InviteUserLoading) {
                    return const CenteredCircularProgressIndicator();
                  }
                  if (state is InvitationLoaded) {
                    return PullToRefresh(
                      onRefresh: () {
                        _inviteUserCubit.getInvitation(0);
                      },
                      child: ListView.separated(
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 15),
                        padding: EdgeInsets.all(12.0),
                        physics: const BouncingScrollPhysics(),
                        itemCount: state.response.inviteUserList!.length,
                        itemBuilder: (context, index) => InviteWidget(
                            isSpecial: false,
                            onDelete: (id) {
                              AppDialog.showConfirmationDialog(
                                  context: context,
                                  onConfirm: () {
                                    _inviteUserCubit.deleteInvite(id);
                                  });
                            },
                            inviteUser: state.response.inviteUserList![index]),
                      ),
                    );
                  }
                  if (state is InviteUserFailure) {
                    return ErrorHandler(exception: state.exception)
                        .buildErrorWidget(
                      context: context,
                      retryCallback: () => _inviteUserCubit.getInvitation(0),
                    );
                  }
                  return Container();
                }),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaders(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            S.current.standardInvite,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
          ),
          BlocBuilder<InviteUserCubit, InviteUserState>(
            builder: (context, state) {
              if (state is! InvitationLoaded) {
                return const SizedBox.shrink();
              }
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(
                      AddStanderInviteScreen.routName,
                      arguments: {"cubit": _inviteUserCubit});
                },
                child: Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    shape: BoxShape.circle,
                    boxShadow: [Helpers.boxShadow(context)],
                  ),
                  child: Center(
                    child: CircleAvatar(
                      backgroundColor: AppColors.primaryColor,
                      radius: 13,
                      child: Icon(
                        Icons.add,
                        color: AppColors.whiteColor,
                      ),
                    ),
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
