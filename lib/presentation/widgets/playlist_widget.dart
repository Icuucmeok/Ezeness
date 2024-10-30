import 'package:ezeness/data/models/playlist/playlist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PlaylistWidget extends StatelessWidget {
  const PlaylistWidget({
    Key? key,
    required this.onTap,
    required this.playlist,
    this.isSelected = false,
  }) : super(key: key);

  final VoidCallback onTap;
  final Playlist playlist;
  final bool isSelected;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.0.dg, vertical: 3.0.dg),
        child: Stack(
          alignment: Alignment.bottomCenter,
          clipBehavior: Clip.antiAlias,
          children: [
            ///Image Container
            Container(
              padding: EdgeInsets.fromLTRB(
                4.0.dg,
                0.0,
                4.0.dg,
                10.0.dg,
              ),
              height: 100.dg,
              width: 85.dg,
              decoration: BoxDecoration(
                border: Border.all(
                    color: isSelected ? Colors.blue : Colors.transparent,
                    width: 1.w),
                borderRadius: BorderRadius.circular(20.0.r),
                color: isSelected
                    ? Colors.blue.shade900
                    : Colors.black26.withOpacity(0.3),
                // image: DecorationImage(
                //   opacity: 0.5,
                //   fit: BoxFit.cover,
                //   image: NetworkImage(playlist.image.toString()),
                // ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  // color: Colors.grey.shade800,
                  border: Border.all(
                      color:
                          Theme.of(context).primaryColorLight.withOpacity(0.2),
                      width: 1.dg),
                  // image: DecorationImage(
                  //   fit: BoxFit.cover,
                  //   image: NetworkImage(category.image.toString()),
                  // ),
                ),
              ),
            ),

            ///Text Container
            Container(
                padding: EdgeInsets.only(
                    top: 5.dg, bottom: 5.dg, right: 5.dg, left: 5.dg),
                alignment: Alignment.center,
                height: 50.dg,
                width: 85.dg,
                decoration: BoxDecoration(
                  color: Colors.black26.withOpacity(0.3),
                  // color: Colors.black87.withOpacity(0.5),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(20.r),
                  ),
                  border: Border.all(color: Colors.transparent, width: 1.w),
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: MediaQuery.of(context).size.width * .3,
                    maxWidth: MediaQuery.of(context).size.width * .4,
                  ),
                  child: LayoutBuilder(builder: (context, constraints) {
                    return Text(
                      playlist.name!,
                      textAlign: TextAlign.center,
                      textScaler: TextScaler.linear(constraints.maxWidth *
                          (.009 % playlist.name!.length)),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            letterSpacing: 0.2,
                            height: 1,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16.sp,
                          ),
                    );
                  }),
                )),
          ],
        ),
      ),
    );
  }
}
