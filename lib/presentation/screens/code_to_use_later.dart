// Widget buildPanelView(BuildContext context) {
//   return SingleChildScrollView(
//     padding: EdgeInsets.symmetric(horizontal: 10.w),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         10.verticalSpace,
//         panelHeader(),
//         8.verticalSpace,
//         buildOrderSummaryCard('VIP products', '5K', '900', context),
//         16.verticalSpace,
//         buildOrderSummaryCard('Order to Lift Up', '5K', '900', context),
//         buildOrderStatusSection(context),
//         8.verticalSpace,
//         buildOrderStatusRefundSection(context),
//         8.verticalSpace,
//         buildOrderStatusCanceledSection(context),
//         8.verticalSpace,
//         buildOrderStatusRejectedSection(context),
//       ],
//     ),
//   );
// }
//
// Widget buildOrderSummaryCard(
//     String title, String total, String coins, BuildContext context) {
//   return Container(
//     padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 14.h),
//     decoration: BoxDecoration(
//         border: Border(
//             bottom: BorderSide(
//               color: AppColors.grey,
//             ))),
//     child: Column(
//       children: [
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(title,
//                     style: Theme.of(context).textTheme.bodyLarge?.copyWith(
//                         fontWeight: FontWeight.w500, fontSize: 14.sp)),
//               ],
//             ),
//             Row(
//               children: [
//                 OrderContainerWidget(
//                   amount: "5K",
//                   title: "Total",
//                 ),
//                 12.horizontalSpace,
//                 OrderContainerWidget(
//                   amount: "900",
//                   title: "Gold Coins",
//                   textColor: AppColors.gold,
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ],
//     ),
//   );
// }
//
// Widget buildOrderStatusSection(BuildContext context) {
//   return Container(
//     width: 340.w,
//     height: 204.h,
//     child: Stack(children: [
//       Positioned(
//         top: 20,
//         left: 0,
//         right: 0,
//         child: Container(
//           padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 14.h),
//           decoration: BoxDecoration(
//             color: Theme.of(context).brightness == Brightness.dark
//                 ? AppColors.darkColor
//                 : AppColors.whiteColor,
//             borderRadius: BorderRadius.circular(8.r),
//           ),
//           child: Column(
//             children: [
//               11.verticalSpace,
//               buildOrderStatusRow('Orders New', '1', context),
//               11.verticalSpace,
//               buildOrderStatusRow('Order In Process', '1', context),
//               11.verticalSpace,
//               buildOrderStatusRow('Ready Orders', '1', context),
//               11.verticalSpace,
//               buildOrderStatusRow('Dispatched Orders', '1', context),
//               11.verticalSpace,
//               buildOrderStatusRow('Delivered Orders', '1', context),
//             ],
//           ),
//         ),
//       ),
//       Positioned(
//           top: 0,
//           left: 0,
//           child: Container(
//             width: 36.w,
//             height: 36.h,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: Theme.of(context).brightness == Brightness.dark
//                   ? AppColors.darkGrey
//                   : AppColors.greyCard,
//             ),
//             child: Icon(Icons.store),
//           )),
//     ]),
//   );
// }
//
// Widget buildOrderStatusRefundSection(BuildContext context) {
//   return Container(
//     width: 340.w,
//     height: 175.h,
//     child: Stack(children: [
//       Positioned(
//         top: 20,
//         left: 0,
//         right: 0,
//         child: Container(
//           padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 14.h),
//           decoration: BoxDecoration(
//             color: Theme.of(context).brightness == Brightness.dark
//                 ? AppColors.darkColor
//                 : AppColors.darkWhite,
//             borderRadius: BorderRadius.circular(8.r),
//           ),
//           child: Column(
//             children: [
//               11.verticalSpace,
//               buildOrderStatusRow('Refund Requests', '1', context),
//               11.verticalSpace,
//               buildOrderStatusRow('Refund Pickup', '1', context),
//               11.verticalSpace,
//               buildOrderStatusRow('Refund Processed', '1', context),
//             ],
//           ),
//         ),
//       ),
//       Positioned(
//           top: 0,
//           left: 0,
//           child: Container(
//             width: 36.w,
//             height: 36.h,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: Theme.of(context).brightness == Brightness.dark
//                   ? AppColors.darkGrey
//                   : AppColors.greyCard,
//             ),
//             child: Icon(Icons.store),
//           )),
//     ]),
//   );
// }
//
// Widget buildOrderStatusCanceledSection(BuildContext context) {
//   return Container(
//     width: 340.w,
//     height: 145.h,
//     child: Stack(children: [
//       Positioned(
//         top: 20,
//         left: 0,
//         right: 0,
//         child: Container(
//           padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 14.h),
//           decoration: BoxDecoration(
//             color: Theme.of(context).brightness == Brightness.dark
//                 ? AppColors.darkColor
//                 : AppColors.whiteColor,
//             borderRadius: BorderRadius.circular(8.r),
//           ),
//           child: Column(
//             children: [
//               11.verticalSpace,
//               buildOrderStatusRow('Canceled Orders', '1', context),
//               11.verticalSpace,
//               buildOrderStatusRow('Canceled In Process', '1', context),
//               11.verticalSpace,
//               buildOrderStatusRow('Canceled Confirm', '1', context),
//             ],
//           ),
//         ),
//       ),
//       Positioned(
//           top: 0,
//           left: 0,
//           child: Container(
//             width: 36.w,
//             height: 36.h,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: Theme.of(context).brightness == Brightness.dark
//                   ? AppColors.darkGrey
//                   : AppColors.greyCard,
//             ),
//             child: Icon(Icons.store),
//           )),
//     ]),
//   );
// }
//
// Widget buildOrderStatusRejectedSection(BuildContext context) {
//   return Container(
//     width: 340.w,
//     height: 147.h,
//     child: Stack(children: [
//       Positioned(
//         top: 20,
//         left: 0,
//         right: 0,
//         child: Container(
//           padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 14.h),
//           decoration: BoxDecoration(
//             color: Theme.of(context).brightness == Brightness.dark
//                 ? AppColors.darkColor
//                 : AppColors.whiteColor,
//             borderRadius: BorderRadius.circular(8.r),
//           ),
//           child: Column(
//             children: [
//               11.verticalSpace,
//               buildOrderStatusRow('Orders rejected', '1', context),
//               11.verticalSpace,
//               buildOrderStatusRow('Refund rejected', '1', context),
//               11.verticalSpace,
//               buildOrderStatusRow('Canceled rejected', '1', context),
//             ],
//           ),
//         ),
//       ),
//       Positioned(
//           top: 0,
//           left: 0,
//           child: Container(
//             width: 36.w,
//             height: 36.h,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: Theme.of(context).brightness == Brightness.dark
//                   ? AppColors.darkGrey
//                   : AppColors.greyCard,
//             ),
//             child: Icon(Icons.store),
//           )),
//     ]),
//   );
// }
//
// Widget buildOrderStatusRow(String title, String value, BuildContext context) {
//   return Row(
//     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//     children: [
//       Text(title,
//           style: Theme.of(context)
//               .textTheme
//               .bodyMedium
//               ?.copyWith(fontWeight: FontWeight.w500, fontSize: 14.sp)),
//       Text(value,
//           style: Theme.of(context)
//               .textTheme
//               .bodyLarge
//               ?.copyWith(fontWeight: FontWeight.bold, fontSize: 16.sp)),
//     ],
//   );
// }
// class panelHeader extends StatelessWidget {
//   const panelHeader({
//     super.key,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
//       decoration: BoxDecoration(
//         color: Theme.of(context).brightness == Brightness.dark
//             ? AppColors.darkColor
//             : AppColors.whiteColor,
//         borderRadius: BorderRadius.circular(22.r),
//         boxShadow: [
//           BoxShadow(
//             color: Theme.of(context).brightness == Brightness.dark
//                 ? AppColors.whiteColor.withOpacity(0.4)
//                 : AppColors.accentShadowColor,
//             offset: Offset(0, 3),
//             blurRadius: 6.r,
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text('Panel',
//               style: Theme.of(context)
//                   .textTheme
//                   .titleMedium
//                   ?.copyWith(fontWeight: FontWeight.bold, fontSize: 14.sp)),
//           7.verticalSpace,
//           Text(
//             'Manage all your order from the panel',
//             style: Theme.of(context)
//                 .textTheme
//                 .titleSmall
//                 ?.copyWith(fontWeight: FontWeight.w400, fontSize: 14.sp),
//           ),
//           20.verticalSpace
//         ],
//       ),
//     );
//   }
// }

// Widget buildPaymentCard(
//     {required String cardDetails,
//       required String cardHolderName,
//       required String expiredDate,
//       required BuildContext context}) {
//   return Container(
//     padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
//     decoration: BoxDecoration(
//         border: Border(
//             bottom: BorderSide(
//               color: AppColors.grey,
//             ))),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Container(
//             height: 18.h,
//             width: 18.w,
//             decoration: BoxDecoration(
//                 color: AppColors.whiteColor.withOpacity(0.6),
//                 border: Border.all(color: AppColors.textLight, width: 1.4.w),
//                 borderRadius: BorderRadius.circular(12.r),
//                 boxShadow: [
//                   BoxShadow(
//                     color: const Color.fromARGB(31, 73, 70, 70),
//                     offset: Offset(0, 3),
//                     blurRadius: 6.r,
//                   )
//                 ])),
//         10.verticalSpace,
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     Text(cardDetails,
//                         style: Theme.of(context)
//                             .textTheme
//                             .titleMedium
//                             ?.copyWith(
//                             fontWeight: FontWeight.w500,
//                             fontSize: 15.sp)),
//                     5.verticalSpace,
//                     Text(cardHolderName,
//                         style: Theme.of(context)
//                             .textTheme
//                             .titleMedium
//                             ?.copyWith(
//                             fontWeight: FontWeight.w500,
//                             fontSize: 15.sp)),
//                     5.verticalSpace,
//                     Text(expiredDate,
//                         style: Theme.of(context)
//                             .textTheme
//                             .titleMedium
//                             ?.copyWith(
//                             fontWeight: FontWeight.w500,
//                             fontSize: 15.sp)),
//                   ],
//                 ),
//               ],
//             ),
//             Icon(
//               CupertinoIcons.creditcard_fill,
//               size: 35.r,
//             )
//           ],
//         ),
//       ],
//     ),
//   );
// }
//
// Widget topUpRequests(BuildContext context) {
//   return SizedBox(
//     height: 180.h,
//     child: Stack(
//       children: [
//         Positioned(
//           top: 0,
//           left: 0,
//           right: 0,
//           child: Container(
//             height: 180.h,
//             // width: 180.w,
//             padding: EdgeInsetsDirectional.only(
//                 top: 75.h, bottom: 10.h, start: 20.w, end: 20.w),
//             decoration: BoxDecoration(
//               color: Theme.of(context).brightness == Brightness.dark
//                   ? AppColors.darkColor
//                   : Colors.grey.shade200,
//               borderRadius: BorderRadius.circular(20.r),
//               boxShadow: [
//                 BoxShadow(
//                   color: AppColors.accentShadowColor,
//                   offset: Offset(0, 3),
//                   blurRadius: 6.r,
//                 ),
//               ],
//             ),
//             child: Column(
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       'Accepted',
//                       style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                           fontSize: 15.sp, fontWeight: FontWeight.w500),
//                     ),
//                     Text(
//                       '10',
//                       style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                         fontSize: 14.sp,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ],
//                 ),
//                 5.verticalSpace,
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       'Pendings',
//                       style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                           fontSize: 15.sp, fontWeight: FontWeight.w500),
//                     ),
//                     Text(
//                       '5',
//                       style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                         fontSize: 14.sp,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ],
//                 ),
//                 15.verticalSpace,
//                 Container(
//                   height: 32.h,
//                   padding: EdgeInsets.symmetric(horizontal: 14.w),
//                   decoration: BoxDecoration(
//                       color: AppColors.whiteColor,
//                       borderRadius: BorderRadius.circular(10.r),
//                       border: Border.all(
//                           color: AppColors.blackColor, width: 0.8.r)),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         'Total income',
//                         style:
//                         Theme.of(context).textTheme.bodyMedium?.copyWith(
//                           fontSize: 15.sp,
//                           fontWeight: FontWeight.w500,
//                           color: AppColors.blackColor,
//                         ),
//                       ),
//                       Row(
//                         children: [
//                           Text(
//                             'AED',
//                             style: Theme.of(context)
//                                 .textTheme
//                                 .bodyMedium
//                                 ?.copyWith(
//                               fontSize: 10.sp,
//                               fontWeight: FontWeight.w500,
//                               color: AppColors.blackColor,
//                             ),
//                           ),
//                           2.horizontalSpace,
//                           Text(
//                             '999',
//                             style: Theme.of(context)
//                                 .textTheme
//                                 .bodyMedium
//                                 ?.copyWith(
//                               fontSize: 16.sp,
//                               fontWeight: FontWeight.w700,
//                               color: AppColors.blackColor,
//                             ),
//                           ),
//                           2.horizontalSpace,
//                           Text(
//                             '.99',
//                             style: Theme.of(context)
//                                 .textTheme
//                                 .bodyMedium
//                                 ?.copyWith(
//                               fontSize: 11.sp,
//                               fontWeight: FontWeight.w500,
//                               color: AppColors.blackColor,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ),
//         Positioned(
//           top: 0,
//           left: 0,
//           right: 0,
//           child: Container(
//             height: 65.h,
//             padding: EdgeInsets.only(left: 20.w, right: 20.w),
//             decoration: BoxDecoration(
//               color: Colors.blue.shade600.withOpacity(0.6),
//               borderRadius: BorderRadius.circular(20.r),
//               boxShadow: [
//                 BoxShadow(
//                   color: const Color.fromARGB(31, 73, 70, 70),
//                   offset: Offset(0, 3),
//                   blurRadius: 6.r,
//                 ),
//               ],
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   children: [
//                     Text(
//                       'Tag Up requests',
//                       style: Theme.of(context)
//                           .textTheme
//                           .titleMedium
//                           ?.copyWith(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 15.sp,
//                           color: AppColors.whiteColor.withOpacity(0.9)),
//                     ),
//                   ],
//                 ),
//                 Text(
//                   '15',
//                   style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                       fontSize: 14.sp,
//                       fontWeight: FontWeight.w500,
//                       color: Colors.white.withOpacity(0.9)),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     ),
//   );
// }