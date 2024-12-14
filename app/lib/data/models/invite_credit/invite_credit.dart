// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:ezeness/data/models/invite_user/invite_user_list.dart';

class InviteCredit {
  final int? id;
  final int? type;
  final int? count;
  final int? total;
  final int? status;
  final int? activeInvitedUser;
  final InviteUserList inviteUserList;

  InviteCredit({
    this.id,
    this.type,
    this.count,
    this.total,
    this.status,
    this.activeInvitedUser,
    required this.inviteUserList,
  });

  int? get remaining {
    if (count == null) return null;
    return (total ?? 0) - count!;
  }

  int? get pending {
    if (activeInvitedUser == null || remaining == null) return null;
    return remaining! - activeInvitedUser!;
  }

  factory InviteCredit.fromJson(Map<String, dynamic> json) => InviteCredit(
        id: json['id'] as int?,
        type: json['type'] as int?,
        count: json['count'] as int?,
        total: json['total'] as int?,
        status: json['status'] as int?,
        activeInvitedUser: json['active_invited_user'] as int?,
        inviteUserList: json['invitations'] != null
            ? InviteUserList.parsedMapToList(json['invitations'])
            : InviteUserList(),
      );

  static parsed(rawJson) {
    return InviteCredit.fromJson(jsonDecode(rawJson)["data"]);
  }
}
