import 'dart:convert';

import 'package:ezeness/data/models/invite_user/invite_user.dart';
import 'package:ezeness/data/models/invite_user/invite_user_list.dart';

import 'invite_credit.dart';

class InviteCreditList {
  final List<InviteCredit>? inviteCreditList;
  final List<InviteUser>? proInvites;

  InviteCreditList({
    this.inviteCreditList,
    this.proInvites,
  });

  int get totalJoinedByPro => (proInvites?.isEmpty ?? true)
      ? 0
      : proInvites
              ?.map((e) => e.totalJoined)
              .reduce((a, b) => (a ?? 0) + (b ?? 0)) ??
          0;

  int get proCount => proInvites?.length ?? 0;

  InviteCredit get proCried => InviteCredit(
        inviteUserList: InviteUserList(
          inviteUserList: proInvites ?? [],
        ),
        count: proCount,
        total: 10,
        activeInvitedUser: totalJoinedByPro,
      );

  static parsed(rawJson) {
    final parsedInvitations =
        jsonDecode(rawJson)["data"]['invitations'].cast<Map<String, dynamic>>();
    final listInvitation = parsedInvitations
        .map<InviteCredit>((json) => InviteCredit.fromJson(json))
        .toList();

    final parsedProInvitations =
        (jsonDecode(rawJson)["data"]['pro_invitations'] as List)
            .cast<Map<String, dynamic>>();
    final List<InviteUser> listProInvitation = parsedProInvitations.isEmpty
        ? []
        : parsedProInvitations
            .map<InviteUser>((json) => InviteUser.fromJson(json))
            .toList();

    return InviteCreditList(
      inviteCreditList: listInvitation,
      proInvites: listProInvitation,
    );
  }

  static parsedToList(rawJson) {
    final parsed = rawJson.cast<Map<String, dynamic>>();
    final list = parsed
        .map<InviteCredit>((json) => InviteCredit.fromJson(json))
        .toList();
    return list;
  }
}
