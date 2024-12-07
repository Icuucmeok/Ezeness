import 'package:ezeness/presentation/screens/profile/about/privacy_policy_screen.dart';
import 'package:ezeness/presentation/screens/profile/about/term_of_use_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../../config/api_config.dart';
import '../../../../generated/l10n.dart';
import '../../../../logic/cubit/app_config/app_config_cubit.dart';

class AboutScreen extends StatefulWidget {
  static const String routName = 'about_screen';
  const AboutScreen({Key? key}) : super(key: key);

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    PackageInfo packageInfo = context.read<AppConfigCubit>().getPackageInfo();
    return Scaffold(
      appBar: AppBar(title: Text(S.current.about)),
      body: Column(
        children: [
          buildAboutItem(
              S.current.privacyPolicy,
              () => Navigator.of(context)
                  .pushNamed(PrivacyPolicyScreen.routName)),
          buildAboutItem(S.current.termOfUse,
              () => Navigator.of(context).pushNamed(TermOfUseScreen.routName)),
          Expanded(child: SizedBox()),
          Column(
            children: [
              Text(
                  "${packageInfo.version} +${packageInfo.buildNumber}  ${ApiConfig.baseURL == "https://api.ezeness.com/api/V1" ? "live" : "dev"}"),
              Text("${packageInfo.appName} © ${DateTime.now().year}"),
            ],
          ),
        ],
      ),
    );
  }

  buildAboutItem(String title, VoidCallback onTap) {
    return ListTile(
      onTap: onTap,
      title: Text(title),
      trailing: Icon(Icons.arrow_forward_ios_outlined),
    );
  }
}
