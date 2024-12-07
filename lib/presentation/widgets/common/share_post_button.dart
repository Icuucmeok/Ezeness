import 'package:ezeness/data/models/post/post.dart';
import 'package:ezeness/presentation/utils/app_dialog.dart';
import 'package:ezeness/presentation/utils/app_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

import '../../../generated/l10n.dart';
import '../../../res/app_res.dart';
import 'common.dart';

class SharePostButton extends StatelessWidget {
  final Post post;
  const SharePostButton({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MoreIconButton(
      icon:CupertinoIcons.paperplane,
      value: S.current.share,
      canGustTap: true,
      onTapIcon: () {
        Navigator.of(context).pop();
        String postLink=Constants.appLinkUrl+"post?${post.id}";
        AppDialog.showMainAppDialog(
            context: context,
            title: S.current.share,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Post ID #${post.id}"),
                    IconButton(
                      onPressed: (){
                        Clipboard.setData(ClipboardData(text: post.id.toString()));
                        AppToast(message: "Copied to Clipboard").show();
                      },
                        icon: Icon(Icons.copy),
                    ),
                  ],
                ),
                ListTile(
                  title:Text("Post Link"),
                  subtitle:Text("$postLink"),
                  contentPadding: EdgeInsets.zero,
                  trailing:  Wrap(
                      spacing: 0,
                    children: [
                      IconButton(
                        onPressed: (){
                          Clipboard.setData(ClipboardData(text:postLink));
                          AppToast(message: "Copied to Clipboard").show();
                        },
                        padding: EdgeInsets.zero,
                        icon: Icon(Icons.copy),
                      ),
                      IconButton(
                        onPressed: ()async{
                          await Share.share("😎 Checkout this amazing post on A New Social Media Platform 'EZENESS'\n$postLink");
                        },
                        padding: EdgeInsets.zero,
                        icon: Icon(CupertinoIcons.paperplane),
                      ),
                    ],
                  ),
                ),

              ],
            ),
        );
      },
    );
  }
}
