import 'package:ezeness/presentation/screens/profile/privacy_security/create_change_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

import '../../../../generated/l10n.dart';

class PrivacySecurityScreen extends StatelessWidget {
  static const String routName = 'privacy_security_screen';
  const PrivacySecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(S.current.privacyAndSecurity)),
      body: Column(
        children: [
          ListTile(
            leading: Icon(
              size: 30,
              IconlyLight.password,
              color: Theme.of(context).primaryColorDark,
            ),
            title: Text(
              S.current.password,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).primaryColorDark,
                fontSize: 15,
              ),
            ),
            onTap: () {
              Navigator.of(context)
                  .pushNamed(CreateChangePasswordScreen.routName);
            },
          ),
        ],
      ),
    );
  }
}
