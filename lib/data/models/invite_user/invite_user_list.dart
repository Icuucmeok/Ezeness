import 'dart:convert';
import 'dart:developer';

import 'invite_user.dart';

class InviteUserList {
  final List<InviteUser>? inviteUserList;

  InviteUserList({
    this.inviteUserList,
  });

  static parsed(rawJson) {
    var parsed = jsonDecode(rawJson)["data"];

    if (parsed is List<dynamic>) {
      parsed.cast<Map<String, dynamic>>();
    } else if (parsed['invitations'] is List<dynamic>) {
      log("parsed: ${parsed['invitations']}");
      parsed = (parsed['invitations']).cast<Map<String, dynamic>>();
    }
    final list =
        parsed.map<InviteUser>((json) => InviteUser.fromJson(json)).toList();
    return InviteUserList(inviteUserList: list);
  }

  static parsedToList(rawJson) {
    final parsed = rawJson.cast<Map<String, dynamic>>();
    final list =
        parsed.map<InviteUser>((json) => InviteUser.fromJson(json)).toList();
    return list;
  }

  static InviteUserList parsedMapToList(List<dynamic> json) {
    final parsed = json.cast<Map<String, dynamic>>();

    return InviteUserList(
      inviteUserList: parsed.map((e) => InviteUser.fromJson(e)).toList(),
    );
  }
}
