import 'package:ezeness/presentation/utils/helpers.dart';
import 'package:ezeness/res/app_res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/models/category/category.dart';

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({
    Key? key,
    required this.onTap,
    required this.category,
    this.isSelected = false,
    this.margin,
  }) : super(key: key);

  final VoidCallback onTap;
  final Category category;
  final bool isSelected;
  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 118.dg,
        width: 85.dg,
        margin: margin ??
            EdgeInsets.symmetric(horizontal: 2.0.dg, vertical: 3.0.dg),
        decoration: BoxDecoration(
          border:
              isSelected ? Border.all(color: Colors.blue, width: 1.w) : null,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20.r),
            bottomRight: Radius.circular(5.r),
            bottomLeft: Radius.circular(5.r),
          ),
          color: Theme.of(context).brightness == Brightness.dark
              ? AppColors.darkColor
              : AppColors.greyCard,
          boxShadow: [Helpers.boxShadow(context)],
        ),
        child: Column(
          children: [
            // Image widget
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20.r),
                  ),
                  color: Theme.of(context).primaryColorDark.withOpacity(0.2),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(category.image.toString()),
                  ),
                ),
              ),
            ),
            // Text Widget
            Expanded(
              flex: 2,
              child: Container(
                padding: EdgeInsets.only(
                    top: 5.dg, bottom: 5.dg, right: 5.dg, left: 5.dg),
                alignment: Alignment.center,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: MediaQuery.of(context).size.width * .3,
                    maxWidth: MediaQuery.of(context).size.width * .4,
                  ),
                  child: LayoutBuilder(builder: (context, constraints) {
                    return Text(
                      category.name!,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      textScaler: TextScaler.linear(constraints.maxWidth *
                          (.009 % category.name!.length)),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            letterSpacing: 0.2,
                            height: 1,
                            color: Theme.of(context).primaryColorDark,
                            fontSize: 16.sp,
                          ),
                    );
                  }),
                ),
              ),
            )
          ],
        ),
      ),
    );

    //return    GestureDetector(
    //     onTap: onTap,
    //     child: Padding(
    //       padding: EdgeInsets.symmetric(horizontal: 2.0.dg, vertical: 3.0.dg),
    //       child: Stack(
    //         alignment: Alignment.bottomCenter,
    //         clipBehavior: Clip.antiAlias,
    //         children: [
    //           ///Image Container
    //           Container(
    //             padding: EdgeInsets.fromLTRB(
    //               4.0.dg,
    //               0.0,
    //               4.0.dg,
    //               10.0.dg,
    //             ),
    //             height: 100.dg,
    //             width: 85.dg,
    //             decoration: BoxDecoration(
    //               border: Border.all(
    //                 color: isSelected ? Colors.blue : Colors.transparent,
    //                 width: 1.w,
    //               ),
    //               borderRadius: BorderRadius.circular(20.0.r),
    //               color: isSelected
    //                   ? Colors.blue.shade900
    //                   : Colors.black26.withOpacity(0.3),
    //               image: DecorationImage(
    //                 opacity: 0.5,
    //                 fit: BoxFit.cover,
    //                 image: NetworkImage(category.image.toString()),
    //               ),
    //             ),
    //             child: Container(
    //               decoration: BoxDecoration(
    //                 shape: BoxShape.circle,
    //                 // color: Colors.grey.shade800,
    //                 border: Border.all(
    //                     color:
    //                         Theme.of(context).primaryColorLight.withOpacity(0.2),
    //                     width: 1.dg),
    //                 image: DecorationImage(
    //                   fit: BoxFit.cover,
    //                   image: NetworkImage(category.image.toString()),
    //                 ),
    //               ),
    //             ),
    //           ),
    //           ///Text Container
    //           Container(
    //               padding: EdgeInsets.only(
    //                   top: 5.dg, bottom: 5.dg, right: 5.dg, left: 5.dg),
    //               alignment: Alignment.center,
    //               height: 50.dg,
    //               width: 85.dg,
    //               decoration: BoxDecoration(
    //                 color: Colors.black26.withOpacity(0.3),
    //                 // color: Colors.black87.withOpacity(0.5),
    //                 borderRadius: BorderRadius.vertical(
    //                   bottom: Radius.circular(20.r),
    //                 ),
    //                 border: Border.all(color: Colors.transparent, width: 1.w),
    //               ),
    //               child: ConstrainedBox(
    //                 constraints: BoxConstraints(
    //                   minWidth: MediaQuery.of(context).size.width * .3,
    //                   maxWidth: MediaQuery.of(context).size.width * .4,
    //                 ),
    //                 child: LayoutBuilder(builder: (context, constraints) {
    //                   return Text(
    //                     // "Kids Education & Training",
    //                     // name,
    //                     category.name!,
    //                     textAlign: TextAlign.center,
    //                     textScaler: TextScaler.linear(constraints.maxWidth *
    //                         (.009 % category.name!.length)),
    //                     style: Theme.of(context).textTheme.bodyLarge?.copyWith(
    //                       letterSpacing: 0.2,
    //                       height: 1,
    //                       color: Colors.white,
    //                       fontWeight: FontWeight.w600,
    //                       fontSize: 16.sp,
    //                     ),
    //                   );
    //                 }),
    //               )),
    //         ],
    //       ),
    //     ),
    //   );
    // }
  }
}
