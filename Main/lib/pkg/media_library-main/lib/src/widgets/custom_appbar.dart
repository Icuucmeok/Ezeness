import 'package:flutter/material.dart';
import 'package:media_library/src/controller/config_controller.dart';
import 'package:provider/provider.dart';

import '../../core/enums.dart';
import '../controller/media_controller.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onPressed;

  const CustomAppBar({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Size get preferredSize => AppBar().preferredSize;

  @override
  Widget build(BuildContext context) {
    final showPreview = context.watch<MediaController>().screenView;
    final configController = context.watch<ConfigController>();

    return showPreview == ScreenView.preview
        ? AppBar(
            leading: Container(),
            backgroundColor: Colors.black,
            actions: [
              TextButton(
                onPressed: () {
                  context.read<MediaController>().clearPickedFiles();
                },
                child: configController.backWidget,
              ),
              const Spacer(),
              TextButton(
                onPressed: onPressed,
                child: configController.nextWidget,
              ),
            ],
          )
        : const SizedBox();
  }
}
