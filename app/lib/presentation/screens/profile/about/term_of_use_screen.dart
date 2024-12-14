import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import '../../../../generated/l10n.dart';
import '../../../../res/app_res.dart';

class TermOfUseScreen extends StatefulWidget {
  static const String routName = 'term_of_use_screen';
  const TermOfUseScreen({Key? key}) : super(key: key);

  @override
  State<TermOfUseScreen> createState() => _TermOfUseScreenState();
}

class _TermOfUseScreenState extends State<TermOfUseScreen>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(S.current.termOfUse)),
      body: SingleChildScrollView(
          child: Padding(
        padding: EdgeInsets.all(8.0),
        child: HtmlWidget(AppData.termOfUse),
      )),
    );
  }
}
