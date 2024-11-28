import 'package:flutter/material.dart';
import 'package:media_library/src/controller/loading_controller.dart';
import 'package:provider/provider.dart';

import '../../../core/enums.dart';
import '../../controller/media_controller.dart';
import 'media_item.dart';
import 'small_preview_images_list.dart';

class PreviewScreen extends StatefulWidget {
  const PreviewScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  late final PageController _pageController;

  @override
  void initState() {
    _pageController = PageController();

    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Consumer<MediaController>(
          builder: (context, controller, child) {
            return PageView.builder(
                controller: _pageController,
                itemCount: controller.pickedFiles.length,
                onPageChanged: (index) {
                  controller.setSelectedMedia(index);
                },
                itemBuilder: (context, i) {
                  return MediaItem(
                    file: controller.pickedFiles[i],
                    index: i,
                    pageController: _pageController,
                  );
                });
          },
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 50.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Consumer<MediaController>(
                    builder: (context, controller, child) {
                      return Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 51, 51,
                              51), // Set the background color to grey
                          borderRadius: BorderRadius.circular(
                              8), // Optional: Add border radius
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.add),
                          color:
                              Colors.grey[300], // Set the icon color to white
                          onPressed: controller.canAddMoreAssets()
                              ? () {
                                  context
                                      .read<MediaController>()
                                      .setScreenView(view: ScreenView.camera);
                                }
                              : null,
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                  SmallPreviewImagesListWidget(
                    pageController: _pageController,
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
