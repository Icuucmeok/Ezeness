import 'package:ezeness/data/utils/error_handler.dart';
import 'package:ezeness/generated/l10n.dart';
import 'package:ezeness/logic/cubit/pro_invitation/pro_invitations_cubit.dart';
import 'package:ezeness/presentation/screens/profile/invite_users/widgets/pro_invite_widget.dart';
import 'package:ezeness/presentation/utils/app_dialog.dart';
import 'package:ezeness/presentation/utils/helpers.dart';
import 'package:ezeness/presentation/widgets/common/common.dart';
import 'package:ezeness/presentation/widgets/pull_to_refresh.dart';
import 'package:ezeness/res/app_res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'add_pro_invite_screen.dart';

class ProInvitesListScreen extends StatefulWidget {
  static const String routName = 'pro_invites_screen';

  const ProInvitesListScreen({Key? key}) : super(key: key);

  @override
  State<ProInvitesListScreen> createState() => _ProInvitesListScreenState();
}

class _ProInvitesListScreenState extends State<ProInvitesListScreen> {
  late ProInvitationsCubit _proInvitationsCubit;

  @override
  void initState() {
    _proInvitationsCubit = context.read<ProInvitationsCubit>();
    _proInvitationsCubit.getProInvitation();
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
        title: Text(S.current.proInvites),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Headers
          _buildHeaders(context),

          Expanded(
            child: BlocConsumer<ProInvitationsCubit, ProInvitationsState>(
                bloc: _proInvitationsCubit,
                listener: (context, state) {
                  if (state is ToggleProInvitationStatusDone) {
                    // AppSnackBar(
                    //         message: S.current.editSuccessfully,
                    //         context: context)
                    //     .showSuccessSnackBar();
                    _proInvitationsCubit.getProInvitation();
                  }
                },
                builder: (context, state) {
                  if (state is ProInvitationsLoading) {
                    return const CenteredCircularProgressIndicator();
                  }
                  if (state is ProInvitationsLoaded) {
                    return PullToRefresh(
                      onRefresh: () {
                        _proInvitationsCubit.getProInvitation();
                      },
                      child: ListView.separated(
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 15),
                        padding: EdgeInsets.all(12.0),
                        physics: const BouncingScrollPhysics(),
                        itemCount: state.response.inviteUserList!.length,
                        itemBuilder: (context, index) => ProInviteWidget(
                            onToggle: (inviteUser) {
                              AppDialog.showConfirmationDialog(
                                  context: context,
                                  message: inviteUser.status == 1
                                      ? S.current.stopInvites
                                      : S.current.continueInvites,
                                  onConfirm: () {
                                    _proInvitationsCubit
                                        .toggleProInvitationStatus(
                                            inviteUser.id!);
                                  });
                            },
                            inviteUser: state.response.inviteUserList![index]),
                      ),
                    );
                  }
                  if (state is ProInvitationsFailure) {
                    return ErrorHandler(exception: state.exception)
                        .buildErrorWidget(
                      context: context,
                      retryCallback: () =>
                          _proInvitationsCubit.getProInvitation(),
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
            S.current.proInvites,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
          ),
          BlocBuilder<ProInvitationsCubit, ProInvitationsState>(
            builder: (context, state) {
              if (state is! ProInvitationsLoaded) {
                return const SizedBox.shrink();
              }
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(AddProInviteScreen.routName,
                      arguments: {"cubit": _proInvitationsCubit});
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
